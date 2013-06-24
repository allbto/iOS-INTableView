//
//  INTableView.m
//  INTableView
//
//  Created by Allan Barbato on 9/7/11.
//  Copyright 2011 Allan Barbato. All rights reserved.
//

#import "INTableView.h"
#import "INTableViewSection.h"

@interface INTableView ()

@property (nonatomic, retain) NSMutableArray *tableViewSections;

@property (nonatomic, copy) void (^pullToRefreshBlock)(INTableView* tableView);
@property (nonatomic, copy) void (^loadMoreBlock)(INTableView* tableView);

@property (nonatomic, retain) PullToRefreshView* pullView;

@property (nonatomic, retain) INTableViewLoadingCell* isBottomLoadingCell;

- (void)initializeTableView;

@end

@implementation INTableView

#pragma mark - Custom Setter/Getter

- (void)setShowSidebar:(BOOL)doShowSidebar
{
    _showSidebar = doShowSidebar;
    if (_showSidebar)
        [self reloadData];
}

- (void)setLoadMoreFromBottom:(BOOL)loadMore withBlock:(void (^)(INTableView *))loadMoreBlock
{
    _loadMoreFromBottom = loadMore;
    
   if (loadMore && loadMoreBlock)
            self.loadMoreBlock = loadMoreBlock;
   else if (_loadMoreBlock)
   {
       [_loadMoreBlock release];
       _loadMoreBlock = nil;
   }
}

- (void)setPullToRefresh:(BOOL)pullToRefresh withBlock:(void (^)(INTableView*))pullBlock
{
    _pullToRefresh = pullToRefresh;
    _pullView.hidden = !pullToRefresh;
    if (pullToRefresh && pullBlock)
        self.pullToRefreshBlock = pullBlock;
    else if (_pullToRefreshBlock)
    {
        [_pullToRefreshBlock release];
        _pullToRefreshBlock = nil;
    }
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    if (loading && [self canPullToRefresh] && self.countOfCells == 0)
    {
        [_pullView setState:PullToRefreshViewStateLoading];
    }
    else
        [_pullView finishedLoading];

    if (loading && (self.countOfCells > 0 || ![self canPullToRefresh]))
    {
        if (!self.isBottomLoadingCell)
            self.isBottomLoadingCell = [INTableViewLoadingCell loadingCell];
        [self addCell:self.isBottomLoadingCell];
    }
    else if (!loading && self.isBottomLoadingCell)
    {
        [self.isBottomLoadingCell retain];
        [self removeCell:self.isBottomLoadingCell];
    }
}

#pragma mark - NSObject

- (void)initializeTableView
{
    self.tableView = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableViewSections = [NSMutableArray array];
    _pullToRefresh = NO;
    _pullToRefreshBlock = nil;
    _pullView = nil;
    _loadMoreBlock = nil;
    _isBottomLoadingCell = nil;
    
    _previousContentOffset = CGPointZero;
}

- (id)init
{
    self = [super init];
    if (self)
        [self initializeTableView];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initializeTableView];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initializeTableView];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
        [self initializeTableView];
    return self;
}

- (id)initWithTableView:(UITableView*)aTableView target:(id<INTableViewDelegate>)aTarget
{
    self = [super initWithFrame:aTableView.frame style:UITableViewStylePlain];
    
    if (self)
    {
        self.autoresizingMask = aTableView.autoresizingMask;//UIViewAutoresizingFlexibleHeight;
        self.target = aTarget;
        self.tableView = aTableView;
        [self initializeTableView];
    }
    return self;
}

- (id)initWithTableView:(UITableView *)aTableView cells:(NSArray*)cells target:(id<INTableViewDelegate>)aTarget
{
    self = [self initWithTableView:aTableView target:aTarget];
    
    if (self)
    {
        INTableViewSection *section = [[[INTableViewSection alloc] initWithHeaderView:[[[UIView alloc] init] autorelease] footerView:nil] autorelease];
        
        [section setCells:cells];
        [self.tableViewSections addObject:section];
    }
    return self;
}

- (void)dealloc
{
    [_tableViewSections release];
    if (_tableView != self)
        [_tableView release];
    
    [self setPullToRefresh:NO withBlock:nil];
    [self setLoadMoreFromBottom:NO withBlock:nil];
    [_isBottomLoadingCell release]; _isBottomLoadingCell = nil;
    [super dealloc];
}

#pragma mark - UIView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    _pullView = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)self.tableView];
    [_pullView setDelegate:self];
    _pullView.hidden = !_pullToRefresh;
    [self.tableView addSubview:_pullView];
}

- (BOOL)resignFirstResponder
{
    for (INTableViewSection* section in self.tableViewSections)
    {
        for (INTableViewCell* cell in section.cells)
            [cell resignFirstResponder];
    }
    return [super resignFirstResponder];
}

#pragma mark - Section Editing

- (void)addSectionWithTitle:(NSString*)title andFooter:(NSString*)footer
{
    INTableViewSection *section = [[[INTableViewSection alloc] initWithTitle:title andFooter:footer] autorelease];
    
    [self.tableViewSections addObject:section];
}

- (void)addSectionAtIndex:(NSInteger)index withTitle:(NSString *)title andFooter:(NSString *)footer
{
    INTableViewSection *section = [[[INTableViewSection alloc] initWithTitle:title andFooter:footer] autorelease];
    
    [self.tableViewSections insertObject:section atIndex:index];
}

- (void)addSectionWithHeaderView:(UIView*)header footerView:(UIView*)footer
{
    INTableViewSection *section = [[[INTableViewSection alloc] initWithHeaderView:header footerView:footer] autorelease];

    [self.tableViewSections addObject:section];
}

- (void)addSectionAtIndex:(NSInteger)index withHeaderView:(UIView*)header andFooterView:(UIView*)footer
{
    INTableViewSection *section = [[[INTableViewSection alloc] initWithHeaderView:header footerView:footer] autorelease];
    
    [self.tableViewSections insertObject:section atIndex:index];
}

- (void)setCells:(NSArray*)cells forSectionAtIndex:(NSInteger)index
{
    INTableViewSection* section = nil;
    
    if (self.tableViewSections.count == 0)
    {
        section = [[[INTableViewSection alloc] initWithHeaderView:[[[UIView alloc] init] autorelease] footerView:nil] autorelease];
        [self.tableViewSections addObject:section];
    }
    
    if (index >= self.tableViewSections.count)
        index = self.tableViewSections.count - 1;
    
    section = [self.tableViewSections objectAtIndex:index];
    [section setCells:cells];
    [self reloadData];
}


- (void)setFooterView:(UIView*)footer forSectionAtIndex:(NSInteger)index
{
    [[self.tableViewSections objectAtIndex:index] setFooterView:footer];
}

- (void)setHeaderView:(UIView*)header forSectionAtIndex:(NSInteger)index
{
    [[self.tableViewSections objectAtIndex:index] setHeaderView:header];
}

- (void)setTitle:(NSString*)title forSectionAtIndex:(NSInteger)index
{
    [[self.tableViewSections objectAtIndex:index] setTitle:title];
}

- (void)setFooter:(NSString*)footer forSectionAtIndex:(NSInteger)index
{
    [[self.tableViewSections objectAtIndex:index] setFooter:footer];
}

#pragma mark - Cells Editing

//TODO: Add cell with animation
- (BOOL)addCell:(INTableViewCell*)cell
{
    if (cell)
    {
        if ([self.tableViewSections count] == 0)
            [self addSectionWithHeaderView:[[[UIView alloc] init] autorelease] footerView:nil];
        
        INTableViewSection *section = [self.tableViewSections lastObject];
        
        cell.indexPath = [NSIndexPath indexPathForRow:section.cellsCount inSection:self.tableViewSections.count - 1];
        [section addCell:cell];
        [self reloadData];
        return YES;
    }
    return NO;
}

- (BOOL)addCell:(INTableViewCell *)cell atIndex:(NSInteger)index inSection:(NSInteger)sectionIndex
{
    if (cell && self.tableViewSections.count > sectionIndex)
    {
        INTableViewSection *section = [self.tableViewSections objectAtIndex:sectionIndex];

        if (section.cellsCount > index)
        {
            cell.indexPath = [NSIndexPath indexPathForRow:index inSection:sectionIndex];
            [section addCell:cell atIndex:index];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]] withRowAnimation:UITableViewRowAnimationBottom];
            [self reloadData];
            return YES;
        }
    }
    return NO;
}

- (BOOL)removeCell:(INTableViewCell*)cell
{
    return [self removeCellAtIndex:cell.indexPath.row inSection:cell.indexPath.section];
}

- (BOOL)removeCell:(INTableViewCell*)cell animation:(UITableViewRowAnimation)animation
{
    return [self removeCellAtIndex:cell.indexPath.row inSection:cell.indexPath.section animation:animation];
}

//TODO: Check if section is correct
- (BOOL)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    if (self.tableViewSections.count > section && [[self.tableViewSections objectAtIndex:section] cellsCount] > index)
    {
        [[self.tableViewSections objectAtIndex:section] removeCellAtIndex:index];
        [self.tableView reloadData];
        return YES;
    }
    return NO;
}

- (BOOL)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section animation:(UITableViewRowAnimation)animation
{
    if (self.tableViewSections.count > section && [[self.tableViewSections objectAtIndex:section] cellsCount] > index)
    {
        [[self.tableViewSections objectAtIndex:section] removeCellAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:section]]
                              withRowAnimation:animation];
        [self.tableView reloadData];
        return YES;
    }
    return NO;
}

- (BOOL)removeAllCellsInSection:(NSInteger)section
{
    if (self.tableViewSections.count > section)
    {
        [[self.tableViewSections objectAtIndex:section] removeAllCells];
        [self.tableView reloadData];
        return YES;
    }
    return NO;
}

- (BOOL)removeAllCellsInSection:(NSInteger)section animation:(UITableViewRowAnimation)animation
{
    if (self.tableViewSections.count > section)
    {
        NSMutableArray* cellsIndexes = [NSMutableArray array];
 
        for (int i = 0 ; i < [self.tableView numberOfRowsInSection:section] ; ++i)
            [cellsIndexes addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        
        [[self.tableViewSections objectAtIndex:section] removeAllCells];
        [self.tableView deleteRowsAtIndexPaths:cellsIndexes withRowAnimation:animation];
        [self.tableView reloadData];
        return YES;
    }
    return NO;
}

- (void)removeAllCells
{
    if (self.tableView)
    {
        while (self.tableViewSections.count > 0)
        {
            INTableViewSection* section = [self.tableViewSections firstObject];
            
            [section removeAllCells];
            [self.tableViewSections removeObjectAtIndex:0];
        }
        [self.tableView reloadData];
    }
}

- (void)removeAllCellsWithAnimation:(UITableViewRowAnimation)animation
{
    while (self.tableViewSections.count > 0)
    {
        INTableViewSection* section = [self.tableViewSections objectAtIndex:0];
        while ([section cellsCount] > 0)
            [self removeCellAtIndex:0 inSection:0 animation:animation];
        [self.tableViewSections removeObjectAtIndex:0];
    }
}

#pragma mark - Cell infos

- (INTableViewCell*)cellForRow:(NSUInteger)row inSection:(NSUInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] cellAtIndex:row];
}

- (NSArray*)cellsInSection:(NSUInteger)section
{
    if (self.tableViewSections.count > section)
        return [NSArray arrayWithArray:[[self.tableViewSections objectAtIndex:section] cells]];
    return nil;
}

- (NSUInteger)countOfCellsInSection:(NSUInteger)section
{
    if (self.tableViewSections.count > section)
        return [[self.tableViewSections objectAtIndex:section] cellsCount];
    return 0;
}

- (NSUInteger)countOfCells
{
    int count = 0;
    
    for (INTableViewSection *section in self.tableViewSections)
        count += [section cellsCount];
    return count;
}

- (NSUInteger)numberOfCellsInSection:(NSUInteger)section
{
    return [self countOfCellsInSection:section];
}

- (NSUInteger)numberOfCells
{
    return [self countOfCells];
}


#pragma mark - TableView Method

- (void)scrollToTopAnimated:(BOOL)animated
{
    if (_tableViewSections.count <= 0) return;
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if (_tableViewSections.count <= 0 || (_tableViewSections.count > 0 && [_tableViewSections.lastObject cellsCount] == 0)) return;
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.tableViewSections.lastObject cellsCount] - 1) inSection:self.tableViewSections.count - 1];
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark - TableView DataSource

- (UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    INTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row];
    }

    //NSLog(@"Cell[%d, %d] : %d", indexPath.section, indexPath.row, cell.retainCount);
    if (!cell.fromTableView)
        [cell belongToTableView:self];
    [cell setIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row] cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableViewSections count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] cellsCount];
}

- (NSString*)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] title];
}

- (NSString*)tableView:(UITableView *)aTableView titleForFooterInSection:(NSInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] footer];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    NSMutableArray *toReturn = [NSMutableArray array];

    if (_showSidebar)
    {
        for (INTableViewSection *section in self.tableViewSections)
        {
            if (section.firstLetter >= 'A')
                [toReturn addObject:[NSString stringWithFormat:@"%c", section.firstLetter]];
        }
    }
    return toReturn;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_showSidebar)
    {
        NSInteger row = 0;
        for (INTableViewSection *section in self.tableViewSections)
        {
            if ([section.title isEqualToString:title])
                return row;
            row++;
        }
        return row;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row] slideToDeleteText];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row] canSlideToDelete];
}

/*- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row] allowEditing];
}
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    INTableViewCell *cell = [[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete && [cell canSlideToDelete])
    {
        [self.tableView beginUpdates];
        
        if (cell.deleteBlock)
            cell.deleteBlock(cell);
        [self.tableView endUpdates];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView* view = [[self.tableViewSections objectAtIndex:section] headerView];
    
    if (view) return view.bounds.size.height;

    return DEFAULT_SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] footerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.tableViewSections.count <= section) return 0;

    INTableViewSection* sec = [self.tableViewSections objectAtIndex:section];
    
    if (sec.footer && ![sec.footer isKindOfClass:[NSNull class]] && sec.footer.length > 0)
        return DEFAULT_SECTION_HEIGHT;

    UIView* view = [sec footerView];
    if (view) return view.bounds.size.height;
    
    return 0;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    INTableViewCell *cell = (INTableViewCell *)[self cellForRow:indexPath.row inSection:indexPath.section];
    
    if (cell.accessoryBlock)
        cell.accessoryBlock(cell);
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    INTableViewCell *cell = [[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row];

    if ([cell canBeSelected] && cell.selectBlock)
        cell.selectBlock(cell);
}

- (void)reloadData
{
    if (self == self.tableView)
        [super reloadData];
    else
        [self.tableView reloadData];
}

#pragma mark - Scroll View delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)aScrollView
{
//    CGPoint         offset = aScrollView.contentOffset;
//    CGRect          bounds = aScrollView.bounds;
//    CGSize          size = aScrollView.contentSize;
//    UIEdgeInsets    inset = aScrollView.contentInset;
//    float           y = offset.y + bounds.size.height - inset.bottom;
//    float           h = size.height;

    if (self.target && [self.target respondsToSelector:@selector(tableViewWillBeginDecelerating:)])
        [self.target tableViewWillBeginDecelerating:self];
    
//    if  (y > (h + BOTTOM_SCROLL_RELOAD_DISTANCE))
//    {
//        if (self.target && [self.target respondsToSelector:@selector(tableViewDidReloadFromBottom:)])
//            [self.target tableViewDidReloadFromBottom:self];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint offset = self.tableView.contentOffset;
    CGSize  size = self.tableView.contentSize;
    
    if (self.target && [self.target respondsToSelector:@selector(tableViewDidScroll:)])
        [self.target tableViewDidScroll:self];
    _previousContentOffset = offset;
        
    if (!self.isLoading && self.countOfCells > 0 && self.canLoadMoreFromBottom && self.loadMoreBlock)
    {
        if (offset.y >= ((size.height - self.tableView.frame.size.height) - ([[[[self.tableViewSections lastObject] cells] lastObject] frame].size.height * NUMBER_OF_CELL_BEFORE_RELOAD_MORE)))
        {
            [self setLoading:YES];
            self.loadMoreBlock(self);
        }
    }
}

#pragma mark - PullToRefreshView Delegate Method

- (void)pullToRefreshViewDidStartLoading:(PullToRefreshView *)view
{
    if (self.pullToRefresh && self.pullToRefreshBlock)
        self.pullToRefreshBlock(self);
}

- (BOOL)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    if (!self.isLoading)
        return self.pullToRefresh;
    return NO;
}

@end

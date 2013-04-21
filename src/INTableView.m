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

- (void)initialize;

@end

@implementation INTableView

@synthesize tableView = _tableView;
@synthesize showSidebar = _showSidebar;
@synthesize target = _target;

#pragma mark - Custom Setter/Getter

- (void)setShowSidebar:(BOOL)doShowSidebar
{
    _showSidebar = doShowSidebar;
    if (_showSidebar)
        [self reloadData];
}

#pragma mark - NSObject

- (void)initialize
{
    self.tableView = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableViewSections = [NSMutableArray array];
}

- (id)init
{
    self = [super init];
    if (self)
        [self initialize];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initialize];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self initialize];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
        [self initialize];
    return self;
}

- (id)initWithTableView:(UITableView*)aTableView target:(id<INTableViewDelegate>)aTarget
{
    self = [super initWithFrame:aTableView.frame style:UITableViewStylePlain];
    
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.target = aTarget;
        aTableView.delegate = self;
        aTableView.dataSource = self;
        self.tableView = aTableView;
        self.tableViewSections = [NSMutableArray array];
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
    [_tableView release];
    [super dealloc];
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
- (void)addCell:(INTableViewCell*)cell
{
    if (cell)
    {
        if ([self.tableViewSections count] == 0)
            [self addSectionWithHeaderView:[[[UIView alloc] init] autorelease] footerView:nil];
        
        INTableViewSection *section = [self.tableViewSections lastObject];
        
        [section addCell:cell];
        [self reloadData];
    }
}
- (void)addCell:(INTableViewCell *)cell atIndex:(NSInteger)index inSection:(NSInteger)sectionIndex
{
    if (cell)
    {
        INTableViewSection *section = [self.tableViewSections objectAtIndex:sectionIndex];

        [section addCell:cell atIndex:index];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]] withRowAnimation:UITableViewRowAnimationBottom];
        [self reloadData];
    }
}
//TODO: Check if section is correct
- (void)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    [[self.tableViewSections objectAtIndex:section] removeCellAtIndex:index];
    [self.tableView reloadData];
}

- (void)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section animation:(UITableViewRowAnimation)animation
{
    [[self.tableViewSections objectAtIndex:section] removeCellAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:section]]
                          withRowAnimation:animation];
    [self.tableView reloadData];
}

- (void)removeAllCellsInSection:(NSInteger)section
{
    [[self.tableViewSections objectAtIndex:section] removeAllCells];
    [self.tableView reloadData];
}

- (void)removeAllCellsInSection:(NSInteger)section animation:(UITableViewRowAnimation)animation
{
    NSMutableArray* cellsIndexes = [NSMutableArray array];
 
    for (int i = 0 ; i < [self.tableView numberOfRowsInSection:section] ; ++i)
        [cellsIndexes addObject:[NSIndexPath indexPathForRow:i inSection:section]];
 
    [[self.tableViewSections objectAtIndex:section] removeAllCells];
    [self.tableView deleteRowsAtIndexPaths:cellsIndexes withRowAnimation:animation];
    [self.tableView reloadData];
}

- (void)removeAllCells
{
    if (self.tableView)
    {
        [self.tableViewSections removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)removeAllCellsWithAnimation:(UITableViewRowAnimation)animation
{
    for (int i = 0 ; i < self.tableViewSections.count ; i++)
    {
        INTableViewSection* section = [self.tableViewSections objectAtIndex:i];
        while ([section cellsCount] > 0)
            [self removeCellAtIndex:0 inSection:i animation:animation];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:animation];
        [self.tableViewSections removeObjectAtIndex:i];
        i--;
    }
}

#pragma mark - Cell infos

- (INTableViewCell*)cellForRow:(NSUInteger)row inSection:(NSUInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] cellAtIndex:row];
}

- (const NSArray*)cellsInSection:(NSUInteger)section
{
    if (section >= [self.tableViewSections count])
        return nil;
    
    return [[self.tableViewSections objectAtIndex:section] cells];
}

- (NSUInteger)countOfCellsInSection:(NSUInteger)section
{
    return [[self.tableViewSections objectAtIndex:section] cellsCount];
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
    INTableViewCell* cell = [[self.tableViewSections objectAtIndex:indexPath.section] cellAtIndex:indexPath.row];
    
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
    UIView* view = [[self.tableViewSections objectAtIndex:section] footerView];
    
    if (view) return view.bounds.size.height;
    
    return DEFAULT_SECTION_HEIGHT;
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
    CGPoint         offset = aScrollView.contentOffset;
    CGRect          bounds = aScrollView.bounds;
    CGSize          size = aScrollView.contentSize;
    UIEdgeInsets    inset = aScrollView.contentInset;
    float           y = offset.y + bounds.size.height - inset.bottom;
    float           h = size.height;

    if (self.target && [self.target respondsToSelector:@selector(tableViewWillBeginDecelerating:)])
        [self.target tableViewWillBeginDecelerating:self];
    
    if  (y > (h + BOTTOM_SCROLL_RELOAD_DISTANCE))
    {
        if (self.target && [self.target respondsToSelector:@selector(tableViewDidReloadFromBottom:)])
            [self.target tableViewDidReloadFromBottom:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint         offset = aScrollView.contentOffset;
    CGRect          bounds = aScrollView.bounds;
    CGSize          size = aScrollView.contentSize;
    UIEdgeInsets    inset = aScrollView.contentInset;
    float           y = offset.y + bounds.size.height - inset.bottom;
    float           h = size.height;
    
    if (self.target && [self.target respondsToSelector:@selector(tableViewDidScroll:)])
        [self.target tableViewDidScroll:self];
        
    if  (y > (h + BOTTOM_SCROLL_RELOAD_DISTANCE))
    {
        if (self.target && [self.target respondsToSelector:@selector(tableViewDidScrollToBottom:)])
            [self.target tableViewDidScrollToBottom:self];
    }    
}

@end

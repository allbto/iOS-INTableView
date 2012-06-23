//
//  INTableView.m
//  iNtra
//
//  Created by Allan on 9/7/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import "INTableView.h"

@interface INTableView ()



@end

@implementation INTableView

@synthesize tableView;
@synthesize tableViewSections;
@synthesize showSidebar;

- (void)setShowSidebar:(BOOL)doShowSidebar
{
    showSidebar = doShowSidebar;
    if (showSidebar)
        [self reloadData];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.tableView = self;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableViewSections = [NSMutableArray array];
    }
    return self;
}

- (id)initWithTableView:(UITableView*)aTableView target:(id)aTarget
{
    self = [super initWithFrame:aTableView.frame style:UITableViewStylePlain];
    
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        target = aTarget;
        aTableView.delegate = self;
        aTableView.dataSource = self;
        self.tableView = aTableView;
        self.tableViewSections = [NSMutableArray array];
    }
    return self;
}

+ (id)tableWithTableView:(UITableView*)aTableView target:(id)aTarget
{ return [[INTableView alloc] initWithTableView:aTableView target:aTarget]; }

- (id)initWithTableView:(UITableView *)aTableView cells:(NSArray*)cells target:(id)aTarget
{
    self = [INTableView tableWithTableView:aTableView target:aTarget];
    
    if (self)
    {
        INTableViewSection *section = [[INTableViewSection alloc] initWithTitle:@"" andFooter:@""];
        [section.tableViewCells setArray:cells];
        [self.tableViewSections addObject:section];
    }
    return self;
}

+ (id)tableWithTableView:(UITableView *)aTableView cells:(NSArray*)cells target:(id)aTarget
{ return [[INTableView alloc] initWithTableView:aTableView cells:cells target:aTarget]; }



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

- (void)addCell:(INTableViewCell*)cell
{
    if (cell)
    {
        if ([self.tableViewSections count] == 0)
            [self addSectionWithTitle:@"" andFooter:@""];
        
        INTableViewSection *section = [self.tableViewSections lastObject];
        [section.tableViewCells addObject:cell];
        [self.tableView reloadData];
    }
}

- (void)addCell:(INTableViewCell *)cell atIndex:(NSIndexPath*)index
{
    if (cell)
    {
        INTableViewSection *section = [self.tableViewSections objectAtIndex:index.section];
        [section.tableViewCells insertObject:cell atIndex:index.row];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView reloadData];
    }
}

- (void)removeAllCells
{
    if (self.tableView)
    {
        [self.tableViewSections removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    [[[self.tableViewSections objectAtIndex:section] tableViewCells] removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:section]]
                     withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

- (void)setTitle:(NSString*)title forSectionAtIndex:(NSInteger)index
{
    [[self.tableViewSections objectAtIndex:index] setTitle:title];
}

- (void)setFooter:(NSString*)footer forSectionAtIndex:(NSInteger)index
{
    [[self.tableViewSections objectAtIndex:index] setFooter:footer];
}

- (INTableViewCell*)cellForRow:(NSInteger)row inSection:(NSInteger)section
{
    return [[[self.tableViewSections objectAtIndex:section] tableViewCells] objectAtIndex:row];
}

- (NSInteger)countOfCellsInSection:(NSInteger)section
{
    return [[[self.tableViewSections objectAtIndex:section] tableViewCells] count];
}

- (NSInteger)countOfCells
{
    int count = 0;
    
    for (INTableViewSection *section in self.tableViewSections)
    {
        count += [section.tableViewCells count];
    }
    return count;
}

#pragma mark - Cells

- (INTableViewCell*)defaultCellWithTitle:(NSString*)title andSelector:(SEL)selector
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Default" target:target selector:selector];
    
    if ([title isKindOfClass:[NSNull class]])
        title = @"";
    cell.textLabel.text = title;
    if (!selector)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return [cell autorelease];
}

- (INTableViewCell*)defaultCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detail
{
    INTableViewCell *cell = [self defaultCellWithTitle:title andSelector:selector];
    cell.detailTextLabel.text = detail;
    return cell;
}

- (INTableViewCell*)defaultCellWithTitle:(NSString*)title andSelector:(SEL)selector argument:(id)argument
{
    INTableViewCell *cell = [self defaultCellWithTitle:title andSelector:selector];
    cell.argument = argument;
    return cell;
}

- (INTableViewCell*)subtitleCellWithTitle:(NSString*)title andSelector:(SEL)selector
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Default" target:target selector:selector];
    
    if ([title isKindOfClass:[NSNull class]])
        title = @"";
    cell.textLabel.text = title;
    if (!selector)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return [cell autorelease];
}

- (INTableViewCell*)subtitleCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detail
{
    INTableViewCell *cell = [self defaultCellWithTitle:title andSelector:selector];
    cell.detailTextLabel.text = detail;
    return cell;
}

- (INTableViewCell*)subtitleCellWithTitle:(NSString*)title andSelector:(SEL)selector argument:(id)argument
{
    INTableViewCell *cell = [self defaultCellWithTitle:title andSelector:selector];
    cell.argument = argument;
    return cell;
}


- (INTableViewCell*)actionCellWithTitle:(NSString*)title andSelector:(SEL)selector
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Action" target:target selector:selector];
    
    if ([title isKindOfClass:[NSNull class]])
        title = @"";
    cell.textLabel.text = title;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithRed:36/255.0 green:71/255.0 blue:113/255.0 alpha:1.0];
    
    return [cell autorelease];
}

- (INTableViewCell*)actionCellWithTitle:(NSString*)title andSelector:(SEL)selector argument:(id)argument
{
    INTableViewCell *cell = [self actionCellWithTitle:title andSelector:selector];
    cell.argument = argument;
    return cell;
}

- (INTableViewCell*)pushSubtitledCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detailText argument:(id)argument
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Push" target:target selector:selector];
    
    if ([title isKindOfClass:[NSNull class]])
        title = @"";
    cell.textLabel.text = title;
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = detailText;
    cell.argument = argument;
    
    return [cell autorelease];
}

- (INTableViewCell*)pushCellWithTitle:(NSString*)title andSelector:(SEL)selector
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Push" target:target selector:selector];
    
    if ([title isKindOfClass:[NSNull class]])
        title = @"";
    cell.textLabel.text = title;
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return [cell autorelease];
}

- (INTableViewCell*)pushCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detailText
{
    INTableViewCell *cell = [self pushCellWithTitle:title andSelector:selector];
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (INTableViewCell*)pushCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detailText argument:(id)argument
{
    INTableViewCell *cell = [self pushCellWithTitle:title andSelector:selector];
    cell.argument = argument;
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (INTableViewCell*)textFieldCellWithText:(NSString*)text prompt:(NSString*)prompt delegate:(id)delegate
{
    INTableViewTextFieldCell *cell = [[INTableViewTextFieldCell alloc] init];
    if (!text || [text isKindOfClass:[NSNull class]])
        text = @"";
    if (!prompt || [text isKindOfClass:[NSNull class]])
        prompt = @"";
    cell.textField.text = text;
    cell.textField.placeholder = prompt;
    cell.delegate = delegate;
    cell.argument = cell;
    return (INTableViewCell*)cell;
}

- (INTableViewCell*)textCellWithText:(NSString*)text editable:(BOOL)edit delegate:(id)delegate
{
    INTableViewTextCell *cell = [[INTableViewTextCell alloc] initEditable:edit];
    cell.textView.text = text;
    cell.delegate = delegate;
    cell.argument = cell;
    cell.tableView = self.tableView;
    return (INTableViewCell*)cell;
}

- (INTableViewCell*)titleTextViewCellWithTitle:(NSString*)title text:(NSString*)text
{
    INTableViewCellTitleTextView *cell = [[INTableViewCellTitleTextView alloc] init];
    
    if (!text || [text isKindOfClass:[NSNull class]])
        text = @"";
    if (!title || [text isKindOfClass:[NSNull class]])
        title = @"";
    cell.height = DEFAULT_CELL_HEIGHT * 2;
    cell.title.text = title;
    cell.textView.text = text;
    return (INTableViewCell*)cell;
}

- (INTableViewLoadingCell*)loadingCellWithloadingLabel:(NSString*)label
{
    INTableViewLoadingCell *cell = [[INTableViewLoadingCell alloc] init];
    
    if (!label || [label isKindOfClass:[NSNull class]] || label.length == 0)
        label = @"Loading...";
    cell.loadingLabel.text = label;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (INTableViewImageCell*)imageCellWithImageNamed:(NSString*)image withTitle:(NSString*)title andDetailText:(NSString*)detail
{
    if (!title || ![title isKindOfClass:[NSString class]])
        title = @"";
    if (!detail || ![detail isKindOfClass:[NSString class]])
        detail = @"";
    
    INTableViewImageCell *cell = [[INTableViewImageCell alloc] initWithImageNamed:image title:title detail:detail];
    cell.target = target;
    return cell;
}

#pragma mark - TableView DataSource

- (UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] objectAtIndex:indexPath.row] setIndexPath:indexPath];
    return [[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] objectAtIndex:indexPath.row] height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableViewSections count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.tableViewSections objectAtIndex:section] tableViewCells] count];
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
    if (showSidebar)
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
    if (showSidebar)
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] count] > indexPath.row)
        return [[[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] objectAtIndex:indexPath.row] allowEditing];
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] objectAtIndex:indexPath.row] allowEditing];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.tableView beginUpdates];
        
        INTableViewCell *cell = [[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] objectAtIndex:indexPath.row];
        
        if (cell.deleteSelector && cell.target && [cell.target respondsToSelector:cell.deleteSelector])
        {
            if (cell.deleteArgument)
                [cell.target performSelector:cell.deleteSelector withObject:cell.deleteArgument];
            else
                [cell.target performSelector:cell.deleteSelector];
        }
        [self.tableView endUpdates];
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    INTableViewCell *cell = (INTableViewCell *)[self cellForRow:indexPath.row inSection:indexPath.section];
    
    if (cell.target && cell.accessorySelector && [cell.target respondsToSelector:cell.accessorySelector])
    {
        if (cell.accessoryArgument)
            [cell.target performSelector:cell.accessorySelector withObject:cell.accessoryArgument];
        else [cell.target performSelector:cell.accessorySelector];
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    INTableViewCell *cell = [[[self.tableViewSections objectAtIndex:indexPath.section] tableViewCells] objectAtIndex:indexPath.row];
    
    if (cell.target && cell.selector && cell.argument)
        [cell.target performSelector:cell.selector withObject:cell.argument];
    else if (cell.target && cell.selector)
        [cell.target performSelector:cell.selector];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end

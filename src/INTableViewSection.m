//
//  INTableViewSection.m
//  INTableView
//
//  Created by Allan Barbato on 9/7/11.
//  Copyright 2011 Allan Barbato. All rights reserved.
//

#import "INTableViewSection.h"
#import "INTableViewCell.h"

@implementation INTableViewSection

@synthesize title, footer, firstLetter;

#pragma mark - NSObject

- (id)initWithTitle:(NSString *)aTitle andFooter:(NSString *)aFooter
{
    self = [super init];
    
    if (self)
    {
        self.title = aTitle;
        self.footer = aFooter;
        self.firstLetter = (self.title.length > 0 ? [self.title characterAtIndex:0] : '\0');

        self.footerView = nil;
        self.headerView = nil;

        tableViewCells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithHeaderView:(UIView*)headerView footerView:(UIView*)footerView
{
    self = [super init];
    
    if (self)
    {
        self.title = @"";
        self.footer = @"";
        
        self.footerView = footerView;
        self.headerView = headerView;

        tableViewCells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [title release];
    [footer release];
    
    [_footerView release];
    [_headerView release];

    [tableViewCells release];
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ : title : %@, footer : %@, cells : %@>", [self class], self.title, self.footer, tableViewCells];
}


#pragma mark - Editing Section

- (void)addCell:(INTableViewCell*)cell
{
    [tableViewCells addObject:cell];
}

- (void)addCell:(INTableViewCell*)cell atIndex:(NSInteger)index
{
    if (index > tableViewCells.count)
        index = tableViewCells.count;
    [tableViewCells insertObject:cell atIndex:index];
}

- (void)setCells:(NSArray*)cells
{
    [self removeAllCells];
    [tableViewCells setArray:cells];
}

- (void)removeCell:(INTableViewCell*)cellToRemove
{
    [cellToRemove release];
    [tableViewCells removeObject:cellToRemove];
}

- (void)removeCellAtIndex:(NSInteger)index
{
    if (index > (tableViewCells.count - 1)) return;
    
    [[tableViewCells objectAtIndex:index] release];
    [tableViewCells removeObjectAtIndex:index];
}

- (void)removeAllCells
{
    for (INTableViewCell* cell in tableViewCells)
        [cell release];
    [tableViewCells removeAllObjects];
}

#pragma mark - Get infos about cells

- (NSInteger)cellsCount
{
    return [tableViewCells count];
}

- (NSArray*)cells
{
    return tableViewCells;
}

- (INTableViewCell*)cellAtIndex:(NSUInteger)index
{
    if (tableViewCells.count == 0) return nil;
    
    if (index > (tableViewCells.count - 1))
        return [tableViewCells lastObject];
    
    return [tableViewCells objectAtIndex:index];
}

@end

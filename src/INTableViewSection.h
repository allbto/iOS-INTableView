//
//  INTableViewSection.h
//  INTableView
//
//  Created by Allan Barbato on 9/7/11.
//  Copyright 2011 Allan Barbato. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_SECTION_HEIGHT 32.0f

@class INTableViewCell;

@interface INTableViewSection : NSObject
{
    NSMutableArray* tableViewCells;
}

// Property
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *footer;
@property (nonatomic, assign) char firstLetter;

@property (nonatomic, retain) UIView* footerView;
@property (nonatomic, retain) UIView* headerView;

// Custom initialisation
- (id)initWithTitle:(NSString*)title andFooter:(NSString*)footer;
- (id)initWithHeaderView:(UIView*)headerView footerView:(UIView*)footerView;

// Editing section
- (void)addCell:(INTableViewCell*)cell;
- (void)addCell:(INTableViewCell*)cell atIndex:(NSInteger)index;
- (void)setCells:(NSArray*)cells;
- (void)removeCell:(INTableViewCell*)cellToRemove;
- (void)removeCellAtIndex:(NSInteger)index;
- (void)removeAllCells;

// Cells infos
- (INTableViewCell*)cellWithTag:(NSString*)tag;
- (NSInteger)cellsCount;
- (NSArray*)cells;
- (INTableViewCell*)cellAtIndex:(NSUInteger)index;

@end

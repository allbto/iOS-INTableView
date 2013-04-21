//
//  INTableView.h
//  INTableView
//
//  Created by Allan Barbato on 9/7/11.
//  Copyright 2011 Allan Barbato. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "INTableViewCell.h"
#import "INTableViewTextCell.h"
#import "INTableViewLoadingCell.h"
#import "INTableViewInputCell.h"

#define BOTTOM_SCROLL_RELOAD_DISTANCE 10

@class INTableViewSection;

@protocol INTableViewDelegate;

@interface INTableView : UITableView
<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*            _tableView;
    NSMutableArray*         _tableViewSections;
    id<INTableViewDelegate> _target;
}

// Property
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign, getter = sidebarIsShown) BOOL showSidebar;
@property (nonatomic, assign) id<INTableViewDelegate> target;

// Custom Initialisation
- (id)initWithTableView:(UITableView*)aTableView target:(id<INTableViewDelegate>)aTarget;
- (id)initWithTableView:(UITableView *)aTableView cells:(NSArray*)cells target:(id<INTableViewDelegate>)aTarget;

// Editing Sections
- (void)addSectionWithTitle:(NSString*)title andFooter:(NSString*)footer;
- (void)addSectionWithHeaderView:(UIView*)header footerView:(UIView*)footer;
- (void)addSectionAtIndex:(NSInteger)index withTitle:(NSString *)title andFooter:(NSString *)footer;
- (void)addSectionAtIndex:(NSInteger)index withHeaderView:(UIView*)header andFooterView:(UIView*)footer;
- (void)setCells:(NSArray*)cells forSectionAtIndex:(NSInteger)index;

- (void)setFooter:(NSString*)footer forSectionAtIndex:(NSInteger)index;
- (void)setTitle:(NSString*)title forSectionAtIndex:(NSInteger)index;
- (void)setFooterView:(UIView*)footer forSectionAtIndex:(NSInteger)index;
- (void)setHeaderView:(UIView*)header forSectionAtIndex:(NSInteger)index;

// Editing Cells
- (void)addCell:(INTableViewCell*)cell;
- (void)addCell:(INTableViewCell *)cell atIndex:(NSInteger)index inSection:(NSInteger)sectionIndex;
- (void)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section;
- (void)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section animation:(UITableViewRowAnimation)animation;
- (void)removeAllCellsInSection:(NSInteger)section;
- (void)removeAllCellsInSection:(NSInteger)section animation:(UITableViewRowAnimation)animation;
- (void)removeAllCells;
- (void)removeAllCellsWithAnimation:(UITableViewRowAnimation)animation;

// Cells infos
- (INTableViewCell*)cellForRow:(NSUInteger)row inSection:(NSUInteger)section;
- (const NSArray*)cellsInSection:(NSUInteger)section;
- (NSUInteger)countOfCellsInSection:(NSUInteger)section;
- (NSUInteger)countOfCells;
// Same as above
- (NSUInteger)numberOfCellsInSection:(NSUInteger)section;
- (NSUInteger)numberOfCells;

// TableView Method
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;

@end

@protocol INTableViewDelegate <NSObject>

@optional
- (void)tableViewDidScroll:(INTableView*)tableView;
- (void)tableViewWillBeginDecelerating:(INTableView*)tableView;

- (void)tableViewDidReloadFromBottom:(INTableView*)tableView;
- (void)tableViewDidScrollToBottom:(INTableView*)tableView;

@end

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
#import "INTableViewSwitchCell.h"
#import "PullToRefreshView.h"

#define NUMBER_OF_CELL_BEFORE_LOADING_MORE 1

@class INTableViewSection;

@protocol INTableViewDelegate;

@interface INTableView : UITableView
<UITableViewDelegate, UITableViewDataSource, PullToRefreshViewDelegate>

//
// Properties
//

// Use this property to have the access the INTableView protocol's methods
// Because I need all of the UITableView delegate's methods to make things right ;)
@property (nonatomic, assign) id<INTableViewDelegate> indelegate;

// Set to YES to show the side bar at the right (used in the contact app to choose a letter)
// Default : NO
@property (nonatomic, assign, getter = sidebarIsShown) BOOL showSidebar;

@property (nonatomic, retain, readonly) PullToRefreshView* pullToRefreshView;

// Use -setPullToRefresh:withBlock: to allow the user to pull to refresh the tableView with the right callback
// Default : NO
@property (nonatomic, readonly, getter = canPullToRefresh) BOOL pullToRefresh;

// Use -setLoadMoreFromBottom:withBlock: to allow the user to load more when he comes to the end of the tableView, with the right callback
// Default : NO
@property (nonatomic, readonly, getter = canLoadMoreFromBottom) BOOL loadMoreFromBottom;

- (void)setPullToRefresh:(BOOL)pullToRefresh withBlock:(void (^)(INTableView*tableView))pullBlock;
- (void)setLoadMoreFromBottom:(BOOL)loadMore withBlock:(void (^)(INTableView*tableView))loadMoreBlock;

// Used when loading more cell
// A INTableViewLoadingCell is placed at the end of the tableView
// Set to NO to hide it and to YES to show it again
// You need to call it when you're done loading your cells, etc.
// Default : NO
@property (nonatomic, assign, getter = isLoading, setter = setLoading:) BOOL loading;

// The loading cell placed at the end of the tableView
// And shown when loading is set to YES
// Pesonalize the INTableViewLoadingCell to change the design
// And you can access it from here to make changes on the go, like labels etc.
@property (nonatomic, readonly) INTableViewLoadingCell* loadMoreLoadingCell;

@property (nonatomic, readonly) CGPoint previousContentOffset;

// Custom Initialisation
- (id)initWithDelegate:(id<INTableViewDelegate>)aIndelegate;
- (id)initWithCells:(NSArray*)cells delegate:(id<INTableViewDelegate>)aIndelegate;

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
- (BOOL)addCell:(INTableViewCell*)cell;
- (BOOL)addCell:(INTableViewCell *)cell atIndex:(NSInteger)index inSection:(NSInteger)sectionIndex;
- (BOOL)removeCell:(INTableViewCell*)cell;
- (BOOL)removeCell:(INTableViewCell*)cell animation:(UITableViewRowAnimation)animation;
- (BOOL)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section;
- (BOOL)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section animation:(UITableViewRowAnimation)animation;
- (BOOL)removeAllCellsInSection:(NSInteger)section;
- (BOOL)removeAllCellsInSection:(NSInteger)section animation:(UITableViewRowAnimation)animation;
- (void)removeAllCells;
- (void)removeAllCellsWithAnimation:(UITableViewRowAnimation)animation;

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;
- (void)moveCell:(INTableViewCell*)cell toIndexPath:(NSIndexPath*)newIndexPath;
- (void)moveCellToLastIndexPath:(INTableViewCell*)cell;

// Cells infos
- (INTableViewCell*)cellWithTag:(NSString*)tag inSection:(NSUInteger)section;
- (INTableViewCell*)cellForRow:(NSUInteger)row inSection:(NSUInteger)section;
- (NSArray*)cellsInSection:(NSUInteger)section;
- (NSUInteger)countOfCellsInSection:(NSUInteger)section;
- (NSUInteger)countOfCells;
// Same as above
- (NSUInteger)numberOfCellsInSection:(NSUInteger)section;
- (NSUInteger)numberOfCells;

// TableView Methods
- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;

// UIResponder Methods
- (BOOL)resignFirstResponder;
- (INTableViewCell*)firstResponderCell;


@end

@protocol INTableViewDelegate <NSObject>

@optional
- (void)tableViewDidScroll:(INTableView*)tableView;
- (void)tableViewWillBeginDecelerating:(INTableView*)tableView;

@end

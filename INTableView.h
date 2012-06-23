//
//  INTableView.h
//  iNtra
//
//  Created by Allan on 9/7/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INTableViewSection.h"
#import "INTableViewCell.h"
#import "INTableViewTextCell.h"
#import "INTableViewTextFieldCell.h"
#import "INTableViewCellTitleTextView.h"
#import "INTableViewLoadingCell.h"
#import "INTableViewImageCell.h"

@interface INTableView : UITableView
<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView;
    NSMutableArray *tableViewSections;
    NSInteger sectionIndex;
    id target;
    BOOL showSidebar;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign, getter = sidebarIsShown) BOOL showSidebar;
@property (nonatomic, retain) NSMutableArray *tableViewSections;

- (id)initWithTableView:(UITableView*)aTableView target:(id)aTarget;

+ (id)tableWithTableView:(UITableView*)aTableView target:(id)target;

- (id)initWithTableView:(UITableView *)aTableView cells:(NSArray*)cells target:(id)aTarget;
+ (id)tableWithTableView:(UITableView *)aTableView cells:(NSArray*)cells target:(id)aTarget;

- (void)addSectionWithTitle:(NSString*)title andFooter:(NSString*)footer;

- (void)addSectionAtIndex:(NSInteger)index withTitle:(NSString *)title andFooter:(NSString *)footer;

- (void)addCell:(INTableViewCell*)cell;

- (void)addCell:(INTableViewCell *)cell atIndex:(NSIndexPath*)index;

- (void)setFooter:(NSString*)footer forSectionAtIndex:(NSInteger)index;

- (void)setTitle:(NSString*)title forSectionAtIndex:(NSInteger)index;

- (INTableViewCell*)cellForRow:(NSInteger)row inSection:(NSInteger)section;

- (void)removeAllCells;

- (void)removeCellAtIndex:(NSInteger)index inSection:(NSInteger)section;

- (NSInteger)countOfCellsInSection:(NSInteger)section;

- (NSInteger)countOfCells;

- (INTableViewCell*)defaultCellWithTitle:(NSString*)title andSelector:(SEL)selector;

- (INTableViewCell*)defaultCellWithTitle:(NSString*)title andSelector:(SEL)selector argument:(id)argument;

- (INTableViewCell*)defaultCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detail;

- (INTableViewCell*)subtitleCellWithTitle:(NSString*)title andSelector:(SEL)selector;

- (INTableViewCell*)subtitleCellWithTitle:(NSString*)title andSelector:(SEL)selector argument:(id)argument;

- (INTableViewCell*)subtitleCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detail;

- (INTableViewCell*)actionCellWithTitle:(NSString*)title andSelector:(SEL)selector;

- (INTableViewCell*)actionCellWithTitle:(NSString*)title andSelector:(SEL)selector argument:(id)argument;

- (INTableViewCell*)pushCellWithTitle:(NSString*)title andSelector:(SEL)selector;

- (INTableViewCell*)pushCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detailText;

- (INTableViewCell*)pushCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detailText argument:(id)argument;

- (INTableViewCell*)pushSubtitledCellWithTitle:(NSString*)title andSelector:(SEL)selector detailText:(NSString*)detailText argument:(id)argument;

- (INTableViewCell*)textCellWithText:(NSString*)text editable:(BOOL)edit delegate:(id)delegate;

- (INTableViewCell*)textFieldCellWithText:(NSString*)text prompt:(NSString*)prompt delegate:(id)delegate;

- (INTableViewCell*)titleTextViewCellWithTitle:(NSString*)title text:(NSString*)text;

- (INTableViewLoadingCell*)loadingCellWithloadingLabel:(NSString*)label;

- (INTableViewCell*)imageCellWithImageNamed:(NSString*)image withTitle:(NSString*)title andDetailText:(NSString*)detail;

@end

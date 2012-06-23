//
//  INTableViewCell.h
//  iNtra
//
//  Created by Allan on 9/7/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_CELL_HEIGHT 44.0

@interface INTableViewCell : UITableViewCell
{
    id target;
    SEL selector;
    SEL accessorySelector;
    SEL deleteSelector;
    id argument;
    id accessoryArgument;
    id deleteArgument;
    CGFloat height;
    NSIndexPath *indexPath;
    BOOL allowEditing;
}

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) SEL accessorySelector;
@property (nonatomic, retain) id argument;
@property (nonatomic, retain) id accessoryArgument;
@property (nonatomic, assign) SEL deleteSelector;
@property (nonatomic, retain) id deleteArgument;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL allowEditing;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)aTarget selector:(SEL)aSelector;

- (void)setAllowEditing:(BOOL)anAllowEditing withSelector:(SEL)aSelector andArgument:(id)anArgument;

- (void)setAllowEditing:(BOOL)anAllowEditing withSelector:(SEL)aSelector;

@end

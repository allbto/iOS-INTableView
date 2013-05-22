//
//  INTableViewSwitchCell.h
//  Demo
//
//  Created by Allan Barbato on 4/22/13.
//  Copyright 2013 Allan Barbato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableViewCell.h"

@interface INTableViewSwitchCell : INTableViewCell

@property (nonatomic, copy) void (^changeBlock)(INTableViewCell*);

+ (INTableViewSwitchCell*)defaultCell;

// IBOutlet goes here


@end
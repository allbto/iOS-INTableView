//
//  INTableViewLoadingCell.h
//  Magenta
//
//  Created by Allan Barbato on 10/18/11.
//  Copyright (c) 2011 Aides. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableViewCell.h"

@interface INTableViewLoadingCell : INTableViewCell

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (retain, nonatomic) IBOutlet UILabel *loadingLabel;

+ (INTableViewLoadingCell*)loadingCell;

@end

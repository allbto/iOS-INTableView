//
//  INTableViewCellTitleTextView.h
//  Magenta
//
//  Created by Allan Barbato on 10/17/11.
//  Copyright (c) 2011 Aides. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableView.h"

@interface INTableViewCellTitleTextView : INTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end

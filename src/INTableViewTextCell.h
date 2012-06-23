//
//  INTableViewTextCell.h
//  iNtra
//
//  Created by Allan on 9/16/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableViewCell.h"

#define INTableViewTextCellIdentifier @"Text"

@protocol INTableViewTextCellDelegate;

@interface INTableViewTextCell : INTableViewCell
<UITextViewDelegate>
{
    UITextView *textView;
    id delegate;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UITableView *tableView;

- (id)initEditable:(BOOL)edit;

@end

@protocol INTableViewTextCellDelegate <NSObject>

@optional
- (void)textCellDidBeginEditing:(UITextView*)aTextView;
- (void)textCellDidEndEditing:(UITextView*)aTextView;
- (void)textCell:(UITextView*)aTextView valueChanged:(NSString*)text;

@end
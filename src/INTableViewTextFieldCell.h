//
//  INTableViewTextFieldCell.h
//  Magenta
//
//  Created by Allan Barbato on 10/6/11.
//  Copyright 2011 Aides. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableViewCell.h"

@protocol INTableViewTextFieldCellDelegate;

@interface INTableViewTextFieldCell : INTableViewCell
<UITextFieldDelegate>
{
    UITextField *textField;
    id delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) id<INTableViewTextFieldCellDelegate> delegate;

- (IBAction)textFieldValueChanged;
- (IBAction)textFieldEditBegin;
- (IBAction)testFieldEditEnd;

@end

@protocol INTableViewTextFieldCellDelegate <NSObject>

@optional
- (void)textFieldCell:(INTableViewTextFieldCell*)cell didBeginEditing:(UITextField*)aTextField;
- (void)textFieldCell:(INTableViewTextFieldCell*)cell didEndEditing:(UITextField*)aTextField;
- (void)textFieldCell:(INTableViewTextFieldCell*)cell valueChanged:(NSString*)text;

- (void)textFieldCellShouldReturn:(INTableViewTextFieldCell *)cell;

@end
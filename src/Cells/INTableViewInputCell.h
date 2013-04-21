//
//  INTableViewInputCell.h
//  Magenta
//
//  Created by Allan Barbato on 10/6/11.
//  Copyright 2011 Aides. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableViewCell.h"

@protocol INTableViewInputCellDelegate;

@interface INTableViewInputCell : INTableViewCell
<UITextFieldDelegate>

@property (nonatomic, copy) void (^beginEditingBlock)(INTableViewInputCell*);
@property (nonatomic, copy) void (^endEditingBlock)(INTableViewInputCell*);
@property (nonatomic, copy) void (^returnBlock)(INTableViewInputCell*);
@property (nonatomic, copy) void (^textChangeBlock)(INTableViewInputCell*, NSString*);

+ (INTableViewInputCell*)inputCellWithTitle:(NSString*)tile prompt:(NSString*)prompt;

//
// XIB Properties
//
@property (nonatomic, retain) IBOutlet UITextField *textField;

- (IBAction)textFieldValueChanged;
- (IBAction)textFieldEditBegin;
- (IBAction)testFieldEditEnd;

@end

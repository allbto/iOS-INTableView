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

@property(nonatomic, assign, getter = canBeEdited) BOOL isEditable;
@property (assign, nonatomic) BOOL                      expendWhenTextChanges;

@property(nonatomic, retain) IBOutlet UITextView*       textView;

@property (nonatomic, copy) void (^beginEditingBlock)(INTableViewTextCell*);
@property (nonatomic, copy) void (^endEditingBlock)(INTableViewTextCell*);
@property (nonatomic, copy) void (^textChangeBlock)(INTableViewTextCell*, NSString*);

- (id)initEditable:(BOOL)edit;

+ (INTableViewTextCell*)textCellWithText:(NSString*)text editable:(BOOL)ed;

@end
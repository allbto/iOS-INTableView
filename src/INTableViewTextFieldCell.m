//
//  INTableViewTextFieldCell.m
//  Magenta
//
//  Created by Allan Barbato on 10/6/11.
//  Copyright 2011 Aides. All rights reserved.
//

#import "INTableViewTextFieldCell.h"

@implementation INTableViewTextFieldCell
@synthesize textField;
@synthesize delegate;

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewTextFieldCell" owner:self options:nil];
    
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewTextFieldCell class]])
            self = object;
    }
    
    if (self)
    {
        self.height = DEFAULT_CELL_HEIGHT;
        self.textField.delegate = self;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (delegate && [delegate respondsToSelector:@selector(textFieldCellShouldReturn:)])
        [delegate textFieldCellShouldReturn:self];
    return YES;
}

- (IBAction)textFieldValueChanged 
{
    if (delegate && [delegate respondsToSelector:@selector(textFieldCell:valueChanged:)])
        [delegate textFieldCell:self valueChanged:self.textField.text];
}

- (IBAction)textFieldEditBegin
{
    if (delegate && [delegate respondsToSelector:@selector(textFieldCell:didBeginEditing:)])
        [delegate textFieldCell:self didBeginEditing:self.textField];
}

- (IBAction)testFieldEditEnd
{
    if (delegate && [delegate respondsToSelector:@selector(textFieldCell:didEndEditing:)])
        [delegate textFieldCell:self didEndEditing:self.textField];
}

- (void)dealloc {
    [textField release];
    [super dealloc];
}
@end

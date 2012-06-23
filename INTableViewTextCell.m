//
//  INTableViewTextCell.m
//  iNtra
//
//  Created by Allan on 9/16/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import "INTableViewTextCell.h"

@implementation INTableViewTextCell
@synthesize textView, tableView;
@synthesize delegate;

- (id)initEditable:(BOOL)edit
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewTextCell" owner:self options:nil];//[super initWithStyle:style reuseIdentifier:INTableViewTextCellIdentifier target:nil selector:nil];
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewTextCell class]])
            self = object;
    }
    
    if (self)
    {
        self.height = 44*3;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textView.editable = edit;
    }
    return self;
}

- (id)init
{ return [self initEditable:YES]; }

- (id)initWithFrame:(CGRect)frame
{
    self = [self initEditable:YES];
    
    if (self)
    {
        self.frame = frame;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [textView release];
    [super dealloc];
}

- (void)textViewDidBeginEditing:(UITextView *)aTextView
{
    UITableViewCell *cell = (UITableViewCell*) [[aTextView superview] superview];
    [tableView scrollToRowAtIndexPath:[tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (delegate && [delegate respondsToSelector:@selector(textCellDidBeginEditing:)])
        [delegate textCellDidBeginEditing:self.textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (delegate && [delegate respondsToSelector:@selector(textCellDidEndEditing:)])
        [delegate textCellDidEndEditing:self.textView];
}

- (void)textViewDidChange:(UITextView *)aTextView
{
    if (delegate && [delegate respondsToSelector:@selector(textCell:valueChanged:)])
    {
        [delegate textCell:aTextView valueChanged:aTextView.text];
    }
}

@end

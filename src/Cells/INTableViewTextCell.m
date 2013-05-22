//
//  INTableViewTextCell.m
//  iNtra
//
//  Created by Allan on 9/16/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import "INTableViewTextCell.h"
#import "INTableView.h"

@implementation INTableViewTextCell

#pragma mark - Setter/Getter

- (void)setEditable:(BOOL)editable
{
    _isEditable = editable;
    self.textView.editable = editable;
}

#pragma mark - Init/Destroy Methods

+ (INTableViewTextCell *)textCellWithText:(NSString *)text editable:(BOOL)ed
{
    INTableViewTextCell* cell = [[INTableViewTextCell alloc] initEditable:ed];
    
    cell.textView.text = text;
    return [cell autorelease];
}

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewTextCell" owner:self options:nil];//[super initWithStyle:style reuseIdentifier:INTableViewTextCellIdentifier target:nil selector:nil];
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewTextCell class]])
            self = object;
    }
    
    if (self)
    {
        self.cellHeight = self.frame.size.height;
        self.isSelectable = NO;
        self.isEditable = NO;
        self.expendWhenTextChanges = NO;

        _beginEditingBlock = nil;
        _endEditingBlock = nil;
        _textChangeBlock = nil;
    }
    return self;
}

- (id)initEditable:(BOOL)edit
{
    self = [self init];
    
    if (self)
    {
        self.editable = edit;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self init];
    
    if (self)
    {
        self.frame = frame;
    }
    return self;
}

- (void)dealloc
{
    [_textView release];
    _textView = nil;
    
    if (_beginEditingBlock)
        [_beginEditingBlock release];
    _beginEditingBlock = nil;

    if (_endEditingBlock)
        [_endEditingBlock release];
    _endEditingBlock = nil;

    if (_textChangeBlock)
        [_textChangeBlock release];
    _textChangeBlock = nil;

    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExpendWhenTextChanges:(BOOL)expendWhenTextChanges
{
    _expendWhenTextChanges = expendWhenTextChanges;
    if (expendWhenTextChanges)
    {
        CGRect frame = _textView.frame;
        frame.size.height = _textView.contentSize.height;
        _textView.frame = frame;
        self.cellHeight = _textView.contentSize.height;
        [self.fromTableView reloadData];
    }
}

#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)aTextView
{
    [self.fromTableView scrollToRowAtIndexPath:[self.fromTableView indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (_beginEditingBlock)
        _beginEditingBlock(self);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_endEditingBlock)
        _endEditingBlock(self);
}

- (void)textViewDidChange:(UITextView *)aTextView
{
    self.expendWhenTextChanges = self.expendWhenTextChanges;
    if (_textChangeBlock)
        _textChangeBlock(self, aTextView.text);
}

@end

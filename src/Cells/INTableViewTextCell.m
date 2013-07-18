//
//  INTableViewTextCell.m
//  iNtra
//
//  Created by Allan on 9/16/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import "INTableViewTextCell.h"
#import "INTableView.h"

@interface INTableViewTextCell ()

@property (nonatomic, assign) BOOL isPrompting;

@end

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
    
    if (!text || ![text isKindOfClass:[NSString class]])
        text = @"";
    cell.textView.text = text;
    return [cell autorelease];
}

+ (INTableViewTextCell *)textCellWithPrompt:(NSString *)prompt
{
    INTableViewTextCell* cell = [[INTableViewTextCell alloc] initEditable:YES];
    
    if (!prompt || ![prompt isKindOfClass:[NSString class]])
        prompt = @"";
    cell.prompt = prompt;
    return [cell autorelease];
}

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewTextCell" owner:self options:nil];//[super initWithStyle:style reuseIdentifier:INTableViewTextCellIdentifier target:nil selector:nil];
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewTextCell class]])
            self = [object retain];
    }
    
    if (self)
    {
        self.cellHeight = self.frame.size.height;
        self.isSelectable = NO;
        self.isEditable = NO;
        self.expendWhenTextChanges = NO;

        self.prompt = @"";
        _isPrompting = NO;
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

- (void)setPrompt:(NSString *)prompt
{
    [_prompt release];
    
    if (!prompt)
    {
        _prompt = nil;
        return;
    }
    _prompt = [prompt retain];
    
    if (self.textView.text.length == 0 && _prompt.length > 0)
    {
        self.textView.textColor = [self.textView.textColor colorWithAlphaComponent:INTEXTCELL_PROMPT_ALPHA];
        self.textView.text = _prompt;
        self.isPrompting = YES;
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
    if (self.isPrompting && ![aTextView.text isEqualToString:self.prompt])
    {
        self.textView.textColor = [self.textView.textColor colorWithAlphaComponent:1];
        self.textView.text = [aTextView.text substringToIndex:1];
        self.isPrompting = NO;
    }
    else if (self.textView.text.length == 0 && self.prompt.length > 0)
    {
        self.textView.textColor = [self.textView.textColor colorWithAlphaComponent:INTEXTCELL_PROMPT_ALPHA];
        self.textView.text = _prompt;
        self.textView.selectedRange = NSMakeRange(0, 0);
        self.isPrompting = YES;
    }


    self.expendWhenTextChanges = self.expendWhenTextChanges;
    if (_textChangeBlock)
        _textChangeBlock(self, aTextView.text);
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (self.isPrompting && textView.selectedRange.location != 0)
    {
        self.textView.selectedRange = NSMakeRange(0, 0);
    }
}

- (BOOL)resignFirstResponder
{
    return [self.textView resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return [self.textView becomeFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [self.textView isFirstResponder];
}

@end

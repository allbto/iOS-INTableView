//
//  INTableViewInputCell.m
//  Magenta
//
//  Created by Allan Barbato on 10/6/11.
//  Copyright 2011 Aides. All rights reserved.
//

#import "INTableViewInputCell.h"

@implementation INTableViewInputCell

+ (INTableViewInputCell*)inputCellWithTitle:(NSString*)title prompt:(NSString*)prompt
{
    INTableViewInputCell *cell = [[INTableViewInputCell alloc] init];
    if (!title || [title isKindOfClass:[NSNull class]])
        title = @"";
    if (!prompt || [prompt isKindOfClass:[NSNull class]])
        prompt = @"";
    cell.textLabel.text = title;
    cell.textField.placeholder = prompt;
    return [cell autorelease];
}

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewInputCell" owner:self options:nil];
    
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewInputCell class]])
            self = [object retain];
    }
    
    if (self)
    {
        self.cellHeight = DEFAULT_CELL_HEIGHT;
        self.textField.delegate = self;

        _beginEditingBlock = nil;
        _endEditingBlock = nil;
        _textChangeBlock = nil;
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

- (void)dealloc
{
    [_textField release];
    _textField = nil;
    
    if (_beginEditingBlock)
        [_beginEditingBlock release];
    _beginEditingBlock = nil;
    
    if (_endEditingBlock)
        [_endEditingBlock release];
    _endEditingBlock = nil;
    
    if (_textChangeBlock)
        [_textChangeBlock release];
    _textChangeBlock = nil;

    if (_returnBlock)
        [_returnBlock release];
    _returnBlock = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_returnBlock)
        _returnBlock(self);
    return YES;
}

- (IBAction)textFieldValueChanged 
{
    if (_textChangeBlock)
        _textChangeBlock(self, _textField.text);
}

- (IBAction)textFieldEditBegin
{
    [self.fromTableView scrollToRowAtIndexPath:[self.fromTableView indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (_beginEditingBlock)
        _beginEditingBlock(self);
}

- (IBAction)testFieldEditEnd
{
    if (_endEditingBlock)
        _endEditingBlock(self);
}

@end

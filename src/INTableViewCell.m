//
//  INTableViewCell.m
//  INTableView
//
//  Created by Allan Barbato on 9/7/11.
//  Copyright 2011 Allan Barbato. All rights reserved.
//

#import "INTableViewCell.h"

static NSString* DEFAULT_CELL_SLIDE_TO_DELETE_TEXT = nil;

@interface INTableViewCell ()

// Initialize the vars
// Used for every UITableViewCell inits
- (void)initializeVars;

@end

@implementation INTableViewCell

#pragma mark - Init and Destroy Methods

- (void)initializeVars
{
    if (DEFAULT_CELL_SLIDE_TO_DELETE_TEXT == nil)
        DEFAULT_CELL_SLIDE_TO_DELETE_TEXT = NSLocalizedString(@"Delete", @"The localized text for delete. Used for INTableViewCell's slide to delete text");
    
    _fromTableView = nil;
    self.cellHeight = DEFAULT_CELL_HEIGHT;
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _slideToDelete = NO;
    self.slideToDeleteText = DEFAULT_CELL_SLIDE_TO_DELETE_TEXT;
    [self setSelectable:YES];
    
    self.selectBlock = nil;
    self.accessoryBlock = nil;
    self.deleteBlock = nil;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self initializeVars];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializeVars];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initializeVars];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectBlock:(void (^)(INTableViewCell*))block
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initializeVars];
        self.selectBlock = block;
    }
    return self;
}

- (void)dealloc
{
    // If you don't care about dealloc, skip this note.
    
    // According to some, it's better to use the -release method then set the pointer to nil. Than use the setter like :
    // _myVar = nil;
    // But if the property retain is set, self.myVar = nil; does exactly the same.
    // As they say, the dealloc is called when the class is being destroyed, so it can bring problems if you call a setter
    // Anyway, I rather do it the perfect way so :

    if (_indexPath)
        [_indexPath release];
    _indexPath = nil;
    if (_slideToDeleteText)
        [_slideToDeleteText release];
    _slideToDeleteText = nil;
    
    if (_selectBlock)
        [_selectBlock release];
    _selectBlock = nil;
    if (_accessoryBlock)
        [_accessoryBlock release];
    _accessoryBlock = nil;
    if (_deleteBlock)
        [_deleteBlock release];
    _deleteBlock = nil;

    if (_fromTableView)
        [_fromTableView release];
    _fromTableView = nil;
    
    [super dealloc];
}

#pragma mark - Setters/Getters

- (void)belongToTableView:(INTableView *)tableView
{
    if (_fromTableView != nil) return;
    
    _fromTableView = [tableView retain];
}

- (void)setSelectable:(BOOL)selectable
{
    _isSelectable = selectable;
    if (selectable)
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    else
        self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)slideToDeleteActivated:(BOOL)activated deleteBlock:(void (^)(INTableViewCell*))block
{
    _slideToDelete = YES;
    self.deleteBlock = block;
}

- (void)slideToDeleteActivated:(BOOL)activated withDeleteText:(NSString*)deleteText deleteBlock:(void (^)(INTableViewCell*))block
{
    self.slideToDeleteText = deleteText;
    [self slideToDeleteActivated:activated deleteBlock:block];
}

#pragma mark - Cells

+ (INTableViewCell*)defaultCellWithTitle:(NSString*)title selectBlock:(void (^)(INTableViewCell*))block
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Default" selectBlock:block];
    
    cell.textLabel.text = ([title isKindOfClass:[NSNull class]] ? @"" : title);
    if (!block)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return [cell autorelease];
}

+ (INTableViewCell*)defaultCellWithTitle:(NSString*)title detailText:(NSString*)detail selectBlock:(void (^)(INTableViewCell*))block
{
    INTableViewCell *cell = [INTableViewCell defaultCellWithTitle:title selectBlock:block];
    cell.detailTextLabel.text = ([detail isKindOfClass:[NSNull class]] ? @"" : detail);
    return cell;
}

+ (INTableViewCell*)subtitleCellWithTitle:(NSString*)title subtitleText:(NSString*)sub selectBlock:(void (^)(INTableViewCell*))block 
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Subtitled" selectBlock:block];
    
    cell.textLabel.text = ([title isKindOfClass:[NSNull class]] ? @"" : title);
    cell.detailTextLabel.text = ([sub isKindOfClass:[NSNull class]] ? @"" : sub);
    if (!block)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return [cell autorelease];
}

+ (INTableViewCell*)actionCellWithTitle:(NSString*)title selectBlock:(void (^)(INTableViewCell*))block
{
    INTableViewCell *cell = [[INTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Action" selectBlock:block];
    
    cell.textLabel.text = ([title isKindOfClass:[NSNull class]] ? @"" : title);
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithRed:36/255.0 green:71/255.0 blue:113/255.0 alpha:1.0];
    
    return [cell autorelease];
}

+ (INTableViewCell*)pushCellWithTitle:(NSString*)title subtitleText:(NSString*)sub selectBlock:(void (^)(INTableViewCell*))block
{
    INTableViewCell *cell = [INTableViewCell subtitleCellWithTitle:title subtitleText:sub selectBlock:block];
    
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return [cell autorelease];
}

+ (INTableViewCell*)imageCellWithImageNamed:(NSString*)image withTitle:(NSString*)title andDetailText:(NSString*)detail selectBlock:(void (^)(INTableViewCell*))block
{
    INTableViewCell *cell = [INTableViewCell subtitleCellWithTitle:title subtitleText:detail selectBlock:block];
    cell.imageView.image = [UIImage imageNamed:image];
    return cell;
}

#pragma mark - UITableViewCell delegate

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

@end

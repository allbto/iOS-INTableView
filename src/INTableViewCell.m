//
//  INTableViewCell.m
//  iNtra
//
//  Created by Allan on 9/7/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import "INTableViewCell.h"


@implementation INTableViewCell

@synthesize target;
@synthesize selector, accessorySelector, deleteSelector;
@synthesize argument, accessoryArgument, deleteArgument;
@synthesize height;
@synthesize indexPath;
@synthesize allowEditing;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        height = 44.0;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)aTarget selector:(SEL)aSelector
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.allowEditing = NO;
        self.target = aTarget;
        self.selector = aSelector;
        self.argument = self;
        self.height = 44.0;
    }
    return self;
}

- (void)setAllowEditing:(BOOL)anAllowEditing withSelector:(SEL)aSelector andArgument:(id)anArgument
{
    self.allowEditing = anAllowEditing;
    self.deleteSelector = aSelector;
    self.deleteArgument = anArgument;
}

- (void)setAllowEditing:(BOOL)anAllowEditing withSelector:(SEL)aSelector
{
    [self setAllowEditing:anAllowEditing withSelector:aSelector andArgument:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
    [super dealloc];
}

@end

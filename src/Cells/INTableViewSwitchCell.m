//
//  INTableViewSwitchCell.m
//  Demo
//
//  Created by Allan Barbato on 4/22/13.
//  Copyright 2013 Allan Barbato. All rights reserved.
//

#import "INTableViewSwitchCell.h"

@implementation INTableViewSwitchCell

#pragma mark - Inits/Destroy Methods

+ (INTableViewSwitchCell*)defaultCell
{
    INTableViewSwitchCell* cell = [[INTableViewSwitchCell alloc] init];

    // Customization goes here
    //
    cell.textLabel.text = @"Lorem Ipsum";
    return [cell autorelease];
}

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewSwitchCell" owner:self options:nil];
    
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewSwitchCell class]])
            self = [object retain];
    }
    
    if (self)
    {
        self.cellHeight = self.frame.size.height;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self init];
}

- (void)dealloc
{
    NSLog(@"%d", self.retainCount);
    [super dealloc];
}

#pragma mark - Setters/Getters

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  INTableViewCellTitleTextView.m
//  Magenta
//
//  Created by Allan Barbato on 10/17/11.
//  Copyright (c) 2011 Aides. All rights reserved.
//

#import "INTableViewCellTitleTextView.h"

@implementation INTableViewCellTitleTextView
@synthesize title;
@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewCellTitleTextView" owner:self options:nil];
    
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewCellTitleTextView class]])
            self = object;
    }
    
    if (self)
    {
        self.title.text = @"";
        self.height = DEFAULT_CELL_HEIGHT * 2;
    }
    return self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [title release];
    [textView release];
    [super dealloc];
}
@end

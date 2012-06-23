//
//  INTableViewLoadingCell.m
//  Magenta
//
//  Created by Allan Barbato on 10/18/11.
//  Copyright (c) 2011 Aides. All rights reserved.
//

#import "INTableViewLoadingCell.h"

@implementation INTableViewLoadingCell
@synthesize loadingIndicator;
@synthesize loadingLabel;

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewLoadingCell" owner:self options:nil];
    
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewLoadingCell class]])
            self = object;
    }
    
    if (self)
    {
        self.height = DEFAULT_CELL_HEIGHT;
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

- (void)dealloc {
    [loadingLabel release];
    [loadingIndicator release];
    [super dealloc];
}
@end

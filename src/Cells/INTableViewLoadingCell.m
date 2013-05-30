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

+ (INTableViewLoadingCell*)loadingCell
{
    INTableViewLoadingCell *cell = [[INTableViewLoadingCell alloc] init];
    
    cell.loadingLabel.text = [NSLocalizedString(@"Loading", nil) stringByAppendingString:@"..."];
    return [cell autorelease];
}

+ (INTableViewLoadingCell*)loadingCellWithloadingLabel:(NSString*)label
{
    INTableViewLoadingCell *cell = [INTableViewLoadingCell loadingCell];
    
    if (!label || [label isKindOfClass:[NSNull class]] || label.length == 0)
        label = [NSLocalizedString(@"Loading", nil) stringByAppendingString:@"..."];
    cell.loadingLabel.text = label;
    return cell;
}

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewLoadingCell" owner:self options:nil];
    
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewLoadingCell class]])
            self = [object retain];
    }
    
    if (self)
    {
        self.cellHeight = DEFAULT_CELL_HEIGHT;
        self.isSelectable = false;
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

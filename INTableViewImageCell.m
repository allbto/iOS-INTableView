//
//  INTableViewImageCell.m
//  Magenta
//
//  Created by Allan Barbato on 10/19/11.
//  Copyright (c) 2011 Aides. All rights reserved.
//

#import "INTableViewImageCell.h"

@implementation INTableViewImageCell
@synthesize mainImage;
@synthesize titleLabel;
@synthesize detailLabel;

- (id)initWithImageNamed:(NSString*)image title:(NSString*)title detail:(NSString*)detail
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"INTableViewImageCell" owner:self options:nil];
    
    for (id object in nib)
    {
        if ([object isKindOfClass:[INTableViewImageCell class]])
            self = object;
    }
    
    if (self)
    {
        self.height = DEFAULT_CELL_HEIGHT * 2;
        if (image && [image isKindOfClass:[NSString class]])
            self.mainImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:image]];
        self.titleLabel.text = title;
        self.detailLabel.text = detail;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithImageNamed:nil title:@"" detail:@""];
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
    [mainImage release];
    [titleLabel release];
    [detailLabel release];
    [super dealloc];
}
@end

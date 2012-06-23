//
//  INTableViewImageCell.h
//  Magenta
//
//  Created by Allan Barbato on 10/19/11.
//  Copyright (c) 2011 Aides. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INTableView.h"

@interface INTableViewImageCell : INTableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *mainImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

- (id)initWithImageNamed:(NSString*)image title:(NSString*)title detail:(NSString*)detail;

@end

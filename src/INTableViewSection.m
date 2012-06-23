//
//  INTableViewSection.m
//  iNtra
//
//  Created by Allan on 9/7/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import "INTableViewSection.h"


@implementation INTableViewSection

@synthesize title, footer, firstLetter;
@synthesize tableViewCells;

- (id)initWithTitle:(NSString *)aTitle andFooter:(NSString *)aFooter
{
    self = [super init];
    
    if (self)
    {
        self.title = aTitle;
        self.footer = aFooter;
        self.tableViewCells = [NSMutableArray array];
        if ([self.title length] > 0)
            firstLetter = [self.title characterAtIndex:0];
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ : title : %@, footer : %@, cells : %@>", [self class], self.title, self.footer, self.tableViewCells];
}

@end

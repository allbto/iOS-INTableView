//
//  INTableViewSection.h
//  iNtra
//
//  Created by Allan on 9/7/11.
//  Copyright 2011 Allan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface INTableViewSection : NSObject
{
    NSString *title;
    NSString *footer;
    NSMutableArray *tableViewCells;
    char firstLetter;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *footer;
@property (nonatomic, retain) NSMutableArray *tableViewCells;
@property (nonatomic, assign) char firstLetter;

- (id)initWithTitle:(NSString*)title andFooter:(NSString*)footer;

@end

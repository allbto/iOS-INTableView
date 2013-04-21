//
//  INTimer.h
//  INTableView
//
//  Created by Allan Barbato on 8/14/12.
//  Copyright (c) 2012 Allan Barbato. All rights reserved.
//
///////////////////////////////////////////////////////////
//
//  This is an easy to use timer to see time ticking
//  If you look for a fancy scheduled timer try to look at the NSTimer
//
//  This has nothing to do with INTableView
//

#import <Foundation/Foundation.h>

@interface INTimer : NSObject
{
    CGFloat _nStart;
    CGFloat _nPause;
    BOOL    _bPaused;
}

@property (readonly, getter = isPaused, nonatomic) BOOL pause;

- (CGFloat)elapsedtime;
- (void)start;
- (void)stop;
- (void)pause;
- (void)setElapsedTime:(CGFloat)nTime;

@end

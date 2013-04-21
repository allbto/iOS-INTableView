//
//  INTimer.m
//  INTableView
//
//  Created by Allan Barbato on 8/14/12.
//  Copyright (c) 2012 Allan Barbato. All rights reserved.
//

#import "INTimer.h"

#include	<sys/time.h>
#include	<time.h>

double		getticks(void)
{
    struct timeval time;
    
    time.tv_sec = 0;
    time.tv_usec = 0;
    gettimeofday(&time, 0);
    return (time.tv_sec + time.tv_usec / 1000000.0);
}

@implementation INTimer

@synthesize pause = _bPaused;

- (id)init
{
    if ((self = [super init]))
    {
        _nStart = 0;
        _nPause = 0;
        _bPaused = YES;
    }
    return self;
}

- (CGFloat)elapsedtime
{
    if (_nPause)
        return (_nPause);
    if (_nStart)
        return (getticks() - _nStart);
    return (0.0);
}

- (void)start
{
    if (_nStart)
    {
        if (_nPause)
            _nStart = getticks() - _nPause;
    }
    else
        _nStart = getticks();
    _nPause = 0;
    _bPaused = false;
}

- (void)stop
{
    _nPause = 0;
    _nStart = 0;
    _bPaused = true;
}

- (void)pause
{
    _bPaused = true;
    _nPause = getticks() - _nStart;
}

- (void)restart
{
    [self stop];
    [self start];
}

- (void)setElapsedTime:(CGFloat)nTime
{
    if (_nPause)
    {
        _nPause = nTime;
        _nStart = 0;
    }
    
    else
    {
        _nStart = getticks() - nTime;
        _nPause = 0;
    }
}

@end

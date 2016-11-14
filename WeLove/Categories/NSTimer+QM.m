//
//  NSTimer+ANZ.m
//  anz
//
//  Created by KevinCao on 16/7/5.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "NSTimer+QM.h"

@implementation NSTimer (QM)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)())block
                                    repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}

@end

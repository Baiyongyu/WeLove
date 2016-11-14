//
//  NSTimer+ANZ.h
//  anz
//
//  Created by KevinCao on 16/7/5.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (QM)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)())block
                                    repeats:(BOOL)repeats;
@end

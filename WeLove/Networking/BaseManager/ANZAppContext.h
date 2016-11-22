//
//  ANZAppContext.h
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANZAppContext : NSObject

@property (nonatomic, readonly) BOOL isReachable;

+ (instancetype)sharedInstance;

@end

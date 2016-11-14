//
//  ANZKeyChain.h
//  inongzi
//
//  Created by KevinCao on 16/8/1.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

static NSString * const kKeyPassword = @"com.qmkj.ant.password";

@interface ANZKeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end

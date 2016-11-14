//
//  UIAlertView+Object.m
//  inongzi
//
//  Created by KevinCao on 16/7/26.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "UIAlertView+Object.h"
#import <objc/runtime.h>

@implementation UIAlertView (Object)

-(NSObject*)object
{
    return objc_getAssociatedObject(self,@selector(object));
}

-(void)setObject:(NSObject *)value
{
    objc_setAssociatedObject(self,@selector(object),(id)value,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

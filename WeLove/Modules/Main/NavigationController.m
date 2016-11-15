//
//  NavigationController.m
//  WeLove
//
//  Created by 宇玄丶 on 16/10/28.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "NavigationController.h"
#import "PictureFullScreenBrowser.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[PictureFullScreenBrowser class]]) {
        return YES;
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[PictureFullScreenBrowser class]]) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end

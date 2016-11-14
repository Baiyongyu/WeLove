//
//  ANTNavigationController.m
//  inongtian
//
//  Created by KevinCao on 2016/10/26.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "ANTNavigationController.h"
#import "PictureFullScreenBrowser.h"

@interface ANTNavigationController ()

@end

@implementation ANTNavigationController

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

//
//  ANTTabBarController.m
//  inongtian
//
//  Created by KevinCao on 2016/10/21.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "ANTTabBarController.h"

#import "LoveViewController.h"
#import "TimeViewController.h"
#import "MineViewController.h"
#import "RootViewController.h"

@interface ANTTabBarController ()

@end

@implementation ANTTabBarController

- (instancetype)init {
    
    if (self = [super init]) {
        // 首页
        LoveViewController *homeVC = [[LoveViewController alloc] init];
        homeVC.tabBarItem.title = @"微爱";
        homeVC.tabBarItem.image = [UIImage imageNamed:@"ln_tab_chat_32x19_"];
        homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"ln_tab_chat_32x19_"];
        
        // 时光
        TimeViewController *timeVC = [[TimeViewController alloc] init];
        timeVC.tabBarItem.title = @"时光";
        timeVC.tabBarItem.image = [UIImage imageNamed:@"ln_tab_timeline_25x19_"];
        timeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"ln_tab_timeline_25x19_"];
        
        // 我的
//        MineViewController *mineVC = [[MineViewController alloc] init];
        RootViewController *mineVC = [[RootViewController alloc] init];
        mineVC.tabBarItem.title = @"我们";
        mineVC.tabBarItem.image = [UIImage imageNamed:@"ln_tab_index_22x19_"];
        mineVC.tabBarItem.selectedImage = [UIImage imageNamed:@"ln_tab_index_22x19_"];
        
        self.tabBar.tintColor = kNavColor;
        self.viewControllers = @[homeVC, timeVC, mineVC];
    }
    return self;
}

@end

//
//  ANTTabBarController.h
//  inongtian
//
//  Created by KevinCao on 2016/10/21.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TabBarIndex) {
    TabBarIndexHome,    // 首页
    TabBarIndexTime,    // 时光
    TabBarIndexChat,    // 聊天
    TabBarIndexMine     // 我的
};

@interface ANTTabBarController : UITabBarController

@end

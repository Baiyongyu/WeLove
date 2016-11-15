//
//  TabBarController.h
//  WeLove
//
//  Created by 宇玄丶 on 16/10/28.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TabBarIndex) {
    TabBarIndexHome,    // 首页
    TabBarIndexTime,    // 时光
    TabBarIndexChat,    // 聊天
    TabBarIndexMine     // 我的
};

@interface TabBarController : UITabBarController

@end

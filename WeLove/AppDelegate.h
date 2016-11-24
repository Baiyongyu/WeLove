//
//  AppDelegate.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import "NavigationController.h"
#import "RCDataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NavigationController *nav;
@property (strong, nonatomic) TabBarController *tabBarController;

@property(nonatomic,retain) NSMutableArray *friendsArray;
@property(nonatomic,retain) NSMutableArray *groupsArray;

/// func
+ (AppDelegate* )shareAppDelegate;

@end


//
//  Globals.h
//  anz
//
//  Created by KevinCao on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#ifndef Globals_h
#define Globals_h


#import <UIKit/UIKit.h>
/*----------------------------常用尺寸-----------------------------*/
//屏幕尺寸
#define kScreenSize           [[UIScreen mainScreen] bounds].size
//屏幕宽度
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define pictureHeight 200.0
#define NAV_HEIGHT 64.0
#define TabBar_Height 49.0

/** 图片尺寸 */
#define IMAGEWIDTH 100
#define IMAGEHEIGHT 120

#define padding 5
#define heightSpaceing 2


/*--------------------------常用默认属性---------------------------*/
//字体 细黑体
#define XiHeiFont(fontSize) [QMUtil getXiHeiFont:fontSize]
//蓝色
#define kBlueColor [UIColor hexStringToColor:@"#32abff"]
//绿色
#define kGreenColor [UIColor hexStringToColor:@"#55bc22"]
//红色
#define kRedColor [UIColor redColor]
// 导航栏颜色  fd5a98
#define kNavColor [UIColor hexStringToColor:@"#ff5a60"]
//淡绿色
#define kLightGreenColor [UIColor hexStringToColor:@"#5ae29d"]
//淡灰色
#define kLightGrayColor [UIColor hexStringToColor:@"#999999"]
//深灰色
#define kDarkGrayColor [UIColor hexStringToColor:@"#727171"]
//浅灰色背景
#define kBgLightGrayColor [UIColor colorWithWhite:0 alpha:0.2]
//默认加载图片
#define kDefaultLoadingImage [UIImage imageNamed:@"no_feed_content"]
//默认无图
#define kDefaultNoImage [UIImage imageNamed:@"no_feed_content"]

/*------------------------------配置参数------------------------------*/
//wifi下手动下载图片
#define kConfigManualDownloadPictures @"kConfigManualDownloadPictures"
//本地记录版本
#define kLocalRecordVersionCode @"kLocalRecordVersionCode"
//百度地图key
#define kBaiduMapKey @"L6Kv0BwUw7abheRGDYskVGKWoenl3qpy"
//融云 key
#define RONGCLOUD_AppKey @"e0x9wycfed23q"
#define RONGCLOUD_TokenY @"JG3tL/VpRU/h+mdxepDZA9O71edud+MM+6xXrbw4gbMSAPSlArTtw6akhltL7d5rvB4QLcs6E+7hWhhM94p5kg==" // 宇哥

#define RONGCLOUD_TokenW @"JfukmMOGpPxyOrKMF0r8ZDXm6C475QYWljt7S8FHv/uyf0pKKHN6sQqpua7kQ9YFUiLc2x69VHIjBDGefoBmwSoFVDVKUg6g" // 小v

/*----------------------------本地持久化------------------------------*/
//Cookie
#define kCookie @"Cookie"
//Session
#define kSession @"Session"

/*------------------------------通知------------------------------*/
//地理位置变更
#define kLocationUpdatedSuccessNotification @"kLocationUpdatedSuccessNotification"
//定位失败
#define kLocationFailedNotification @"kLocationFailedNotification"
//登录状态改变
#define kLoginStatusChangedNotification @"kLoginStatusChangedNotification"

/*-----------------------------常用宏-----------------------------*/
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define kRootNavigation ((AppDelegate *)[[UIApplication sharedApplication] delegate]).nav
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kRootWindow [UIApplication sharedApplication].windows[0]
#define kDefaultViewBackgroundColor [UIColor hexStringToColor:@"#f3f3f0"]
#define userManager [UserManager sharedInstance]
#define locationManager [LocationManager sharedInstance]
#define rootContext (((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext)
#define kCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
/*-----------------------------文件路径-----------------------------*/
#define kSearchHistoryPath @"SearchHistory"
#define kUserAgreementFilePath @"user_agreement"


/*-----------------------------首页刚进入界面时卡片展示动画-----------------------------*/
static inline CAKeyframeAnimation *GetPopAnimation() {
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.5;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1f, 0.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    popAnimation.keyTimes = @[@0.2f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return popAnimation;
}


#endif /* Globals_h */

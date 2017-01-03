//
//  ShareSDKManagers.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/29.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "ShareSDKManagers.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@implementation ShareSDKManagers

- (void)getShareSDKManagersLaunchOption:(NSDictionary *)option {
    
    [ShareSDK registerApp:ShareSDK_AppKey activePlatforms:@[
                                                            @(SSDKPlatformTypeCopy),
                                                            @(SSDKPlatformTypeMail),
                                                            @(SSDKPlatformTypeSMS),
                                                            @(SSDKPlatformTypeSinaWeibo),
                                                            @(SSDKPlatformTypeWechat),
                                                            @(SSDKPlatformSubTypeWechatTimeline),
                                                            @(SSDKPlatformSubTypeQQFriend),
                                                            @(SSDKPlatformSubTypeQZone)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:XinLang_AppKey
                                          appSecret:XinLang_AppSecret
                                        redirectUri:@"http://www.sharesdk.cn"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                      appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:TXQQ_AppID
                                     appKey:TXQQ_AppKey
                                   authType:SSDKAuthTypeBoth];
                break;
                
            default:
                break;
        }
    }];
}

@end

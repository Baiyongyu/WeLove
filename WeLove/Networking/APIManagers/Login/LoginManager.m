//
//  LoginAPIManager.m
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "LoginManager.h"

@interface LoginManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic,copy) void (^loginSuccessBlock)();
@property (nonatomic,copy) void (^loginFailureBlock)();
@end

@implementation LoginManager
@synthesize errorMessage;

#pragma mark - public
+ (void)autoReloginSuccess:(void(^)())success failure:(void(^)())failure
{
    LoginManager *loginManager = [[LoginManager alloc] init];
    loginManager.paramSource = (id)loginManager;
    loginManager.delegate = (id)loginManager;
    loginManager.validator = (id)loginManager;
    if (userManager.userInfo.phoneNumber.length && userManager.userInfo.password.length) {
        loginManager.loginSuccessBlock = ^ {
            success();
        };
        loginManager.loginFailureBlock = ^ {
            failure();
        };
        [loginManager loadDataWithHUDOnView:nil];
    } else {
        failure();
    }
}

#pragma mark - APIManagerValidator
- (BOOL)manager:(BaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([data[@"code"] integerValue]==20000) {
        userManager.userInfo.isLogin = YES;
        NSDictionary *dataDic = data[@"data"];
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            userManager.userInfo.userId = [QMUtil checkString:dataDic[@"user_id"]];
        }
        [userManager saveUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChangedNotification object:nil];
        return YES;
    }
    NSString *message = data[@"message"];
    if (message.length) {
        errorMessage = message;
    }
    return NO;
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager
{
    if (manager==self) {
        if (self.loginSuccessBlock) {
            self.loginSuccessBlock();
        }
    }
}

- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager
{
    if (manager==self) {
        if (self.loginFailureBlock) {
            self.loginFailureBlock();
        }
        return;
    }
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(BaseAPIManager *)manager
{
    if (manager==self) {
        return @{@"account":userManager.userInfo.phoneNumber,
                 @"pwd":[QMUtil sha512Encode:userManager.userInfo.password]};
    }
    return nil;
}

#pragma mark - APIManager
- (NSString *)methodName
{
    return Login_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}

@end

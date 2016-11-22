//
//  BaseAPIManager.m
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseAPIManager.h"
#import "ANZAppContext.h"
#import "ANZResponse.h"
#import "ANZAPIProxy.h"
#import "LoginManager.h"

@interface BaseAPIManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, copy, readwrite) NSString *successMessage;
@property (nonatomic, readwrite) APIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong)UIView *hudSuperView;
@property (nonatomic, assign)NSInteger reloginCount;
@end
@implementation BaseAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _paramSource = nil;
        _errorType = APIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(APIManager)]) {
            self.child = (id <APIManager>)self;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - calling api
- (NSInteger)loadDataWithHUDOnView:(UIView *)view
{
    [self cancelAllRequests];
    if (view) {
        self.hudSuperView = view;
        [MBProgressHUD showHUDOnView:view animated:YES];
    }
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    if ([self isReachable]) {
        if ([self.child respondsToSelector:@selector(requestSerializer)]) {
            [ANZAPIProxy sharedInstance].requestSerializer = self.child.requestSerializer;
        } else {
            [ANZAPIProxy sharedInstance].requestSerializer = [AFJSONRequestSerializer serializer];
        }
        if ([self.child respondsToSelector:@selector(responseSerializer)]) {
            [ANZAPIProxy sharedInstance].responseSerializer = self.child.responseSerializer;
        } else {
            [ANZAPIProxy sharedInstance].responseSerializer = [AFJSONResponseSerializer serializer];
        }
        [[ANZAPIProxy sharedInstance] callAPIWithRequestType:self.child.requestType params:params methodName:self.child.methodName uploadBlock:[self.paramSource respondsToSelector:@selector(uploadBlock:)]?[self.paramSource uploadBlock:self]:nil success:^(ANZResponse *response) {
            [self successedOnCallingAPI:response];
        } fail:^(ANZResponse *response) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response.response;
            NSLog(@"%ld",httpResponse.statusCode);
            if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]] && httpResponse.statusCode==401) {
                [self failedOnCallingAPI:response withErrorType:APIManagerErrorLoginTimeout];
            } else {
                [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeDefault];
            }
        }];
        [self.requestIdList addObject:@(requestId)];
        return requestId;
        
    } else {
        [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeNoNetWork];
        return requestId;
    }
    return requestId;
}

- (void)successedOnCallingAPI:(ANZResponse *)response
{
    if (self.hudSuperView) {
        [MBProgressHUD hideHUDOnView:self.hudSuperView animated:YES];
//        if ([response.responseObject isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *responseDic = response.responseObject;
//            if ([ANTUtil checkString:responseDic[@"message"]].length) {
//                [MBProgressHUD showTip:responseDic[@"message"]];
//            }
//        }
    }
    [self removeRequestIdWithRequestID:response.requestId];
    self.responseData = response.responseObject;
    if ([self.validator manager:self isCorrectWithCallBackData:response.responseObject]) {
        if ([self.child respondsToSelector:@selector(reformData:)]) {
            [self.child reformData:response.responseObject];
        }
        [self.delegate managerCallAPIDidSuccess:self];
    } else {
        [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(ANZResponse *)response withErrorType:(APIManagerErrorType)errorType
{
    if (self.hudSuperView) {
        [MBProgressHUD hideHUDOnView:self.hudSuperView animated:YES];
    }
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    switch (errorType) {
        case APIManagerErrorTypeDefault:
            self.errorMessage = [self handelError:response.error];
            break;
        case APIManagerErrorTypeSuccess:
            break;
        case APIManagerErrorTypeNoContent:
            break;
        case APIManagerErrorTypeParamsError:
            break;
        case APIManagerErrorTypeTimeout:
            self.errorMessage = @"请求超时";
            break;
        case APIManagerErrorTypeNoNetWork:
            self.errorMessage = @"网络异常";
            break;
        case APIManagerErrorLoginTimeout:
            self.errorMessage = @"登录超时";
            break;
        default:
            break;
    }
    if (self.errorType==APIManagerErrorLoginTimeout) {
        WS(weakSelf);
        if (!self.reloginCount && ![self isKindOfClass:[LoginManager class]]) {
            self.reloginCount++;
            [LoginManager autoReloginSuccess:^{
                [weakSelf loadDataWithHUDOnView:self.hudSuperView];
            } failure:^{
                userManager.userInfo.isLogin = NO;
                [userManager saveUserInfo];
                [weakSelf.delegate managerCallAPIDidFailed:self];
            }];
        } else {
            userManager.userInfo.isLogin = NO;
            [userManager saveUserInfo];
            [weakSelf.delegate managerCallAPIDidFailed:self];
        }
    } else {
        [self.delegate managerCallAPIDidFailed:self];
    }
}

#pragma mark - private methods
- (void)cancelAllRequests
{
    [[ANZAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[ANZAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (NSString *)handelError:(NSError*)error {
    NSString *errorMsg = @"请求异常";
    if (error) {
        NSData *responseData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
            if ([response isKindOfClass:[NSDictionary class]]) {
                errorMsg = [QMUtil checkString:response[@"message"]];
                return errorMsg;
            }
        }
        if ([QMUtil checkNumber:error.userInfo[@"_kCFStreamErrorCodeKey"]].integerValue==-2102) {
            errorMsg = @"请求超时";
        }
    }
    return errorMsg;
}

#pragma mark - getters and setters
- (BOOL)isReachable
{
    BOOL isReachability = [ANZAppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = APIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

@end

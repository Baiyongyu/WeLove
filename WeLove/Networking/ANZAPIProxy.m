//
//  ANZAPIProxy.m
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANZAPIProxy.h"
@interface ANZAPIProxy ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation ANZAPIProxy

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ANZAPIProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ANZAPIProxy alloc] init];
    });
    return sharedInstance;
}

- (NSInteger)callAPIWithRequestType:(APIManagerRequestType)requestType params:(NSDictionary *)params methodName:(NSString *)methodName uploadBlock:(void (^)(id <AFMultipartFormData> formData))uploadBlock success:(ANZCallback)success fail:(ANZCallback)fail
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_BASE_URL,methodName];
    NSNumber *requestId = [self callApi:urlString requestType:requestType params:params uploadBlock:uploadBlock success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *dataTask = self.dispatchTable[requestID];
    [dataTask cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (NSNumber *)callApi:(NSString *)URLString requestType:(APIManagerRequestType)requestType params:(NSDictionary *)params uploadBlock:(void (^)(id <AFMultipartFormData> formData))uploadBlock success:(ANZCallback)success fail:(ANZCallback)fail
{
    // 之所以不用getter，是因为如果放到getter里面的话，每次调用self.recordedRequestId的时候值就都变了，违背了getter的初衷
    NSNumber *requestId = [self generateRequestId];
    
    self.sessionManager.requestSerializer = self.requestSerializer;
    self.sessionManager.requestSerializer.timeoutInterval = 10;
    self.sessionManager.responseSerializer = self.responseSerializer;
    
    [self setCookie];
    // 跑到这里的block的时候，就已经是主线程了。
    NSURLSessionDataTask *dataTask;
    switch (requestType)
    {
        case APIManagerRequestTypeGet:
        {
            dataTask = [self.sessionManager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:requestId task:task responseObject:responseObject success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailRequest:requestId task:task error:error fail:fail];
            }];
        }
            break;
        case APIManagerRequestTypePost:
        {
            dataTask = [self.sessionManager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:requestId task:task responseObject:responseObject success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailRequest:requestId task:task error:error fail:fail];
            }];
        }
            break;
        case APIManagerRequestTypeUpload:
        {
            self.sessionManager.requestSerializer.timeoutInterval = 20;
            dataTask = [self.sessionManager POST:URLString parameters:params constructingBodyWithBlock:uploadBlock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:requestId task:task responseObject:responseObject success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailRequest:requestId task:task error:error fail:fail];
            }];
        }
            break;
        case APIManagerRequestTypeDelete:
        {
            dataTask = [self.sessionManager DELETE:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:requestId task:task responseObject:responseObject success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailRequest:requestId task:task error:error fail:fail];
            }];
        }
            break;
        case APIManagerRequestTypePut:
        {
            dataTask = [self.sessionManager PUT:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:requestId task:task responseObject:responseObject success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailRequest:requestId task:task error:error fail:fail];
            }];
        }
            break;
        default:
            break;
    }
    
    self.dispatchTable[requestId] = dataTask;
    return requestId;
}

- (void)handelSuccessRequst:(NSNumber *)requestId task:(NSURLSessionDataTask *)task responseObject:(id)responseObject success:(ANZCallback)success
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    //存储归档后的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cookiesData forKey:kCookie];
    [self setCookie];
    
    NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
    if (storedTask == nil) {
        // 如果这个task是被cancel的，那就不用处理回调了。
        return;
    } else {
        [self.dispatchTable removeObjectForKey:requestId];
    }
    
    ANZResponse *response = [[ANZResponse alloc] initWithResponse:task.response requestId:requestId responseObject:responseObject];
    
    success?success(response):nil;
}

- (void)handelFailRequest:(NSNumber *)requestId task:(NSURLSessionDataTask *)task error:(NSError *)error fail:(ANZCallback)fail
{
    NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
    if (storedTask == nil) {
        // 如果这个task是被cancel的，那就不用处理回调了。
        return;
    } else {
        [self.dispatchTable removeObjectForKey:requestId];
    }
    
    ANZResponse *response = [[ANZResponse alloc] initWithResponse:task.response requestId:requestId error:error];
    
    fail?fail(response):nil;
}

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

- (void)setCookie
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:kCookie]) {
        return;
    }
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:kCookie]];
    
    if (cookies) {
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }
}

#pragma mark - getters and setters

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    }
    return _sessionManager;
}

- (NSString *)cookie
{
    return [QMUtil checkString:[[NSUserDefaults standardUserDefaults] valueForKey:kCookie]];
}

@end

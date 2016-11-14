//
//  AddActivityManager.m
//  inongtian
//
//  Created by KevinCao on 2016/11/2.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "AddActivityManager.h"

@interface AddActivityManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation AddActivityManager
@synthesize errorMessage;

#pragma mark - APIManagerValidator
- (BOOL)manager:(BaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([data[@"code"] integerValue]==20000) {
        return YES;
    }
    NSString *message = data[@"message"];
    if (message.length) {
        errorMessage = message;
    }
    return NO;
}

#pragma mark - APIManager
- (void)reformData:(NSDictionary *)data
{
    
}

- (NSString *)methodName
{
    return Add_Activity_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}

@end






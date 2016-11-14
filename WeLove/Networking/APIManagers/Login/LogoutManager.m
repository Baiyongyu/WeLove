//
//  LogoutManager.m
//  anz
//
//  Created by KevinCao on 16/7/14.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "LogoutManager.h"

@interface LogoutManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation LogoutManager
@synthesize errorMessage;

#pragma mark - APIManagerValidator
- (BOOL)manager:(BaseAPIManager *)manager isCorrectWithCallBackData:(NSData *)data
{
    return YES;
}

#pragma mark - APIManager
- (NSString *)methodName
{
    return Logout_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}

- (AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer
{
    return [AFHTTPResponseSerializer serializer];
}

@end

//
//  SensorListManager.m
//  ant
//
//  Created by KevinCao on 16/8/26.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "SensorListManager.h"

@interface SensorListManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation SensorListManager
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
    return Sensor_List_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

@end

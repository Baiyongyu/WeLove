//
//  WaterQualitySensorTypeManager.m
//  ant
//
//  Created by KevinCao on 16/8/23.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "WaterQualitySensorTypeManager.h"

@interface WaterQualitySensorTypeManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation WaterQualitySensorTypeManager
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
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *sensorTypeDic in [QMUtil checkArray:data[@"data"]]) {
        WaterSensorTypeModel *sensorTypeInfo = [[WaterSensorTypeModel alloc] init];
        sensorTypeInfo.sensorType = [QMUtil checkString:sensorTypeDic[@"peng_type"]];
        sensorTypeInfo.sensorName = [QMUtil checkString:sensorTypeDic[@"sensor_name"]];
        [tmpArray addObject:sensorTypeInfo];
    }
    self.sensorTypeList = tmpArray;
}

- (NSString *)methodName
{
    return Water_Quality_Sensor_Type_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

@end



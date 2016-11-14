//
//  WaterSensorManager.m
//  ant
//
//  Created by KevinCao on 16/8/23.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "WaterSensorManager.h"

@interface WaterSensorManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation WaterSensorManager
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
    for (NSDictionary *sensorDic in [QMUtil checkArray:data[@"data"]]) {
        SensorModel *sensorData = [[SensorModel alloc] init];
        sensorData.sensorId = [QMUtil checkString:sensorDic[@"peng_no"]];
        sensorData.sensorName = [QMUtil checkString:sensorDic[@"peng_name"]];
        sensorData.sensorType = [QMUtil checkString:sensorDic[@"peng_type"]];
        sensorData.sensorValue = [NSNumber numberWithDouble:[QMUtil checkString:sensorDic[@"sensor_value"]].doubleValue];
        sensorData.alertMaxValue = [QMUtil checkNumber:sensorDic[@"max_alert_value"]];
        sensorData.alertMinValue = [QMUtil checkNumber:sensorDic[@"min_alert_value"]];
        sensorData.maxValue = [QMUtil checkNumber:sensorDic[@"max_value"]];
        sensorData.minValue = [QMUtil checkNumber:sensorDic[@"min_value"]];
        sensorData.alertStatus = [QMUtil checkNumber:sensorDic[@"status"]].boolValue;
        sensorData.fieldName = [QMUtil checkString:sensorDic[@"field_name"]];
        [tmpArray addObject:sensorData];
    }
    self.waterSensorList = tmpArray;
}

- (NSString *)methodName
{
    return Water_Quality_Sensor_List_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

@end

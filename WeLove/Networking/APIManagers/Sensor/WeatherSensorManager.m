//
//  WeatherSensorManager.m
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "WeatherSensorManager.h"

@interface WeatherSensorManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation WeatherSensorManager
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
        sensorData.sensorName = [QMUtil checkString:sensorDic[@"title"]];
        sensorData.sensorType = [QMUtil checkString:sensorDic[@"peng_type"]];
        sensorData.sensorValue = [NSNumber numberWithDouble:[QMUtil checkString:sensorDic[@"value"]].doubleValue];
        sensorData.sensorDisplayValue = [QMUtil checkString:sensorDic[@"translate_value"]];
        sensorData.alertMaxValue = [QMUtil checkNumber:sensorDic[@"max_alert_value"]];
        sensorData.alertMinValue = [QMUtil checkNumber:sensorDic[@"min_alert_value"]];
        sensorData.maxValue = [QMUtil checkNumber:sensorDic[@"max_value"]];
        sensorData.minValue = [QMUtil checkNumber:sensorDic[@"min_value"]];
        [tmpArray addObject:sensorData];
    }
    self.weatherSensorList = tmpArray;
}

- (NSString *)methodName
{
    return Weather_Sensor_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

@end

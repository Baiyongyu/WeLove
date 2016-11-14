//
//  SensorListManager.m
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "FieldSensorListManager.h"

@interface FieldSensorListManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation FieldSensorListManager
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
    if (!self.sensorListData) {
        self.sensorListData = [[SensorListModel alloc] init];
    }
    CGFloat contentHeight = 120;
    NSDictionary *dataDic = data[@"data"];
    if ([dataDic isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *weatherSensorArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *weatherSensorDic in [QMUtil checkArray:dataDic[@"weather_monitor"]]) {
            SensorModel *sensorData = [[SensorModel alloc] init];
            sensorData.sensorName = [QMUtil checkString:weatherSensorDic[@"title"]];
            sensorData.sensorValue = [NSNumber numberWithDouble:[QMUtil checkString:weatherSensorDic[@"value"]].doubleValue];
            sensorData.sensorDisplayValue = [QMUtil checkString:weatherSensorDic[@"translate_value"]];
            sensorData.alertMaxValue = [QMUtil checkNumber:weatherSensorDic[@"max_alert_value"]];
            sensorData.alertMinValue = [QMUtil checkNumber:weatherSensorDic[@"min_alert_value"]];
            sensorData.maxValue = [QMUtil checkNumber:weatherSensorDic[@"max_value"]];
            sensorData.minValue = [QMUtil checkNumber:weatherSensorDic[@"min_value"]];
            [weatherSensorArray addObject:sensorData];
        }
        self.sensorListData.weatherSensorList = weatherSensorArray;
        if (self.sensorListData.weatherSensorList.count%3==0) {
            contentHeight += (kScreenWidth/3-20)*(self.sensorListData.weatherSensorList.count/3);
        } else {
            contentHeight += (kScreenWidth/3-20)*(self.sensorListData.weatherSensorList.count/3+1);
        }
        
        NSMutableArray *waterQualitySensorArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *waterQualitySensorDic in [QMUtil checkArray:dataDic[@"water_monitor"]]) {
            SensorModel *sensorData = [[SensorModel alloc] init];
            sensorData.sensorName = [QMUtil checkString:waterQualitySensorDic[@"title"]];
            sensorData.sensorValue = [NSNumber numberWithDouble:[QMUtil checkString:waterQualitySensorDic[@"value"]].doubleValue];
            sensorData.sensorDisplayValue = [QMUtil checkString:waterQualitySensorDic[@"translate_value"]];
            sensorData.alertMaxValue = [QMUtil checkNumber:waterQualitySensorDic[@"max_alert_value"]];
            sensorData.alertMinValue = [QMUtil checkNumber:waterQualitySensorDic[@"min_alert_value"]];
            sensorData.maxValue = [QMUtil checkNumber:waterQualitySensorDic[@"max_value"]];
            sensorData.minValue = [QMUtil checkNumber:waterQualitySensorDic[@"min_value"]];
            [waterQualitySensorArray addObject:sensorData];
        }
        self.sensorListData.waterQualitySensorList = waterQualitySensorArray;
        
        if (self.sensorListData.waterQualitySensorList.count%3==0) {
            contentHeight += (kScreenWidth/3-20)*(self.sensorListData.waterQualitySensorList.count/3);
        } else {
            contentHeight += (kScreenWidth/3-20)*(self.sensorListData.waterQualitySensorList.count/3+1);
        }
    }
    self.sensorListData.contentHeight = contentHeight;

}

- (NSString *)methodName
{
    return Field_Sensor_List_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

@end

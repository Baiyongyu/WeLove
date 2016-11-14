//
//  SensorModel.m
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "SensorModel.h"

@implementation SensorModel

- (id)copyWithZone:(NSZone *)zone
{
    SensorModel *newItem = [[SensorModel allocWithZone:zone] init];
    newItem.sensorId = self.sensorId;
    newItem.sensorName = self.sensorName;
    newItem.sensorType = self.sensorType;
    newItem.sensorValue = self.sensorValue;
    newItem.sensorDisplayValue = self.sensorDisplayValue;
    newItem.alertMaxValue = self.alertMaxValue;
    newItem.alertMinValue = self.alertMinValue;
    newItem.maxValue = self.maxValue;
    newItem.minValue = self.minValue;
    newItem.alertStatus = self.alertStatus;
    newItem.fieldName = self.fieldName;
    return newItem;
}

@end

@implementation SensorListModel

- (id)copyWithZone:(NSZone *)zone
{
    SensorListModel *newItem = [[SensorListModel allocWithZone:zone] init];
    newItem.weatherSensorList = [self.weatherSensorList copy];
    newItem.waterQualitySensorList = [self.waterQualitySensorList copy];
    newItem.contentHeight = self.contentHeight;
    return newItem;
}

@end

@implementation WaterSensorTypeModel

- (id)copyWithZone:(NSZone *)zone
{
    WaterSensorTypeModel *newItem = [[WaterSensorTypeModel allocWithZone:zone] init];
    newItem.sensorType = self.sensorType;
    newItem.sensorName = self.sensorName;
    return newItem;
}

@end

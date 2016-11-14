//
//  SensorModel.h
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SensorModel : NSObject
//传感器编号
@property(nonatomic,copy)NSString *sensorId;
//传感器名称
@property(nonatomic,copy)NSString *sensorName;
//传感器类型
@property(nonatomic,copy)NSString *sensorType;
//传感器值
@property(nonatomic,copy)NSNumber *sensorValue;
//传感器显示值(如风向等)
@property(nonatomic,copy)NSString *sensorDisplayValue;
//警戒上限
@property(nonatomic,copy)NSNumber *alertMaxValue;
//警戒下限
@property(nonatomic,copy)NSNumber *alertMinValue;
//上限
@property(nonatomic,copy)NSNumber *maxValue;
//下限
@property(nonatomic,copy)NSNumber *minValue;
//状态
@property(nonatomic,assign)BOOL alertStatus;
//田块名
@property(nonatomic,copy)NSString *fieldName;
@end

@interface SensorListModel : NSObject
//气象传感器列表
@property(nonatomic,copy)NSArray *weatherSensorList;
//水质传感器列表
@property(nonatomic,copy)NSArray *waterQualitySensorList;
//内容高度
@property(nonatomic,assign)CGFloat contentHeight;
@end

@interface WaterSensorTypeModel : NSObject
//传感器类别
@property(nonatomic,copy)NSString *sensorType;
//传感器名称
@property(nonatomic,copy)NSString *sensorName;
@end

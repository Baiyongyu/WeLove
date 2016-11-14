//
//  WeatherModel.m
//  ant
//
//  Created by KevinCao on 16/8/17.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (id)copyWithZone:(NSZone *)zone
{
    WeatherModel *newItem = [[WeatherModel allocWithZone:zone] init];
    newItem.weatherValue = self.weatherValue;
    newItem.weatherValueName = self.weatherValueName;
    newItem.date = self.date;
    newItem.maxTemp = self.maxTemp;
    newItem.minTemp = self.minTemp;
    newItem.avgTemp = self.avgTemp;
    newItem.maxPm25 = self.maxPm25;
    newItem.minPm25 = self.minPm25;
    newItem.avgPm25 = self.avgPm25;
    newItem.weatherImage = self.weatherImage;
    newItem.weatherTimeList = [self.weatherTimeList copy];
    return newItem;
}

@end

@implementation WeatherTimeLineModel

- (id)copyWithZone:(NSZone *)zone
{
    WeatherTimeLineModel *newItem = [[WeatherTimeLineModel allocWithZone:zone] init];
    newItem.weatherValue = self.weatherValue;
    newItem.weatherValueName = self.weatherValueName;
    newItem.time = self.time;
    newItem.timeValue = self.timeValue;
    newItem.avgTemp = self.avgTemp;
    newItem.weatherImage = self.weatherImage;
    return newItem;
}

@end

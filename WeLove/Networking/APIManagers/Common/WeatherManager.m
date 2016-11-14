//
//  WeatherManager.m
//  ant
//
//  Created by KevinCao on 16/8/16.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "WeatherManager.h"

@interface WeatherManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation WeatherManager
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
    self.weatherList = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i=0; i<5; i++) {
        WeatherModel *weatherData = [[WeatherModel alloc] init];
        [self.weatherList addObject:weatherData];
    }
    NSMutableArray *timeLineWeatherList = [[NSMutableArray alloc] initWithCapacity:24];
    for (int i=0; i<24; i++) {
        WeatherTimeLineModel *weatherTimeLineData = [[WeatherTimeLineModel alloc] init];
        [timeLineWeatherList addObject:weatherTimeLineData];
    }
    NSDictionary *dataDic = data[@"data"];
    if ([dataDic isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDic = dataDic[@"result"];
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            //一周天气预报
            NSDictionary *dailyDic = resultDic[@"daily"];
            if ([dailyDic isKindOfClass:[NSDictionary class]]) {
                //一周天气
                NSArray *skyconArray = [QMUtil checkArray:dailyDic[@"skycon"]];
                for (int i=0; i<MIN(skyconArray.count, self.weatherList.count); i++) {
                    NSDictionary *skyconDic = skyconArray[i];
                    if ([skyconDic isKindOfClass:[NSDictionary class]]) {
                        WeatherModel *weatherData = self.weatherList[i];
                        weatherData.date = [QMUtil getDateFromeString:[QMUtil checkString:skyconDic[@"date"]]];
                        weatherData.weatherValue = [QMUtil checkString:skyconDic[@"value"]];
                        weatherData.weatherValueName = [self getWeatherValueNameFromWeatherValue:weatherData.weatherValue];
                        weatherData.weatherImage = [self getImageFromWeatherValue:weatherData.weatherValue];
                    }
                }
                //一周气温
                NSArray *temperatureArray = [QMUtil checkArray:dailyDic[@"temperature"]];
                for (int i=0; i<MIN(temperatureArray.count, self.weatherList.count); i++) {
                    NSDictionary *temperatureDic = temperatureArray[i];
                    if ([temperatureDic isKindOfClass:[NSDictionary class]]) {
                        WeatherModel *weatherData = self.weatherList[i];
                        weatherData.maxTemp = [QMUtil checkNumber:temperatureDic[@"max"]];
                        weatherData.minTemp = [QMUtil checkNumber:temperatureDic[@"min"]];
                        weatherData.avgTemp = [QMUtil checkNumber:temperatureDic[@"avg"]];
                    }
                }
                NSArray *pm25Array = [QMUtil checkArray:dailyDic[@"pm25"]];
                for (int i=0; i<MIN(pm25Array.count, self.weatherList.count); i++) {
                    NSDictionary *pm25Dic = pm25Array[i];
                    if ([pm25Dic isKindOfClass:[NSDictionary class]]) {
                        WeatherModel *weatherData = self.weatherList[i];
                        weatherData.maxPm25 = [QMUtil checkNumber:pm25Dic[@"max"]];
                        weatherData.minPm25 = [QMUtil checkNumber:pm25Dic[@"min"]];
                        weatherData.avgPm25 = [QMUtil checkNumber:pm25Dic[@"avg"]];
                        weatherData.airQuality = [self getAirQualityFromPm25:weatherData.avgPm25.floatValue];
                    }
                }
            }
            //小时天气预报
            NSDictionary *hourlyDic = resultDic[@"hourly"];
            if ([hourlyDic isKindOfClass:[NSDictionary class]]) {
                //小时天气
                NSArray *skyconArray = [QMUtil checkArray:hourlyDic[@"skycon"]];
                for (int i=0; i<MIN(skyconArray.count, timeLineWeatherList.count); i++) {
                    NSDictionary *skyconDic = skyconArray[i];
                    if ([skyconDic isKindOfClass:[NSDictionary class]]) {
                        WeatherTimeLineModel *weatherTimeLineData = timeLineWeatherList[i];
                        weatherTimeLineData.time = [QMUtil getDateFromeString:[QMUtil checkString:skyconDic[@"datetime"]]];
                        NSString *timeString = [QMUtil checkString:skyconDic[@"datetime"]];
                        if (i==0) {
                            weatherTimeLineData.timeValue = @"现在";
                        } else {
                            weatherTimeLineData.timeValue = [timeString substringWithRange:NSMakeRange(timeString.length-5, 5)];
                        }
                        weatherTimeLineData.weatherValue = [QMUtil checkString:skyconDic[@"value"]];
                        weatherTimeLineData.weatherValueName = [self getWeatherValueNameFromWeatherValue:weatherTimeLineData.weatherValue];
                        weatherTimeLineData.weatherImage = [self getImageFromWeatherValue:weatherTimeLineData.weatherValue];
                    }
                }
                //小时气温
                NSArray *temperatureArray = [QMUtil checkArray:hourlyDic[@"temperature"]];
                for (int i=0; i<MIN(temperatureArray.count, timeLineWeatherList.count); i++) {
                    NSDictionary *temperatureDic = temperatureArray[i];
                    if ([temperatureDic isKindOfClass:[NSDictionary class]]) {
                        WeatherTimeLineModel *weatherTimeLineData = timeLineWeatherList[i];
                        weatherTimeLineData.avgTemp = [QMUtil checkNumber:temperatureDic[@"value"]];
                    }
                }
            }
            WeatherModel *weatherData = self.weatherList[0];
            weatherData.weatherTimeList = timeLineWeatherList;
        }
    }
}

- (NSString *)methodName
{
    return Weather_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

#pragma mark - private
- (UIImage *)getImageFromWeatherValue:(NSString *)weatherValue
{
    NSDictionary *weatherImageDic = @{@"CLEAR_DAY":[UIImage imageNamed:@"iconfont_qing"],
                                      @"CLEAR_NIGHT":[UIImage imageNamed:@"iconfont_qingye"],
                                      @"PARTLY_CLOUDY_DAY":[UIImage imageNamed:@"iconfont_duoyun"],
                                      @"PARTLY_CLOUDY_NIGHT":[UIImage imageNamed:@"iconfont_duoyunyewan"],
                                      @"CLOUDY":[UIImage imageNamed:@"iconfont_yinbaitian"],
                                      @"RAIN":[UIImage imageNamed:@"iconfont_my_yu"],
                                      @"SLEET":[UIImage imageNamed:@"iconfont_dongyu"],
                                      @"SNOW":[UIImage imageNamed:@"iconfont_zhongxue"],
                                      @"WIND":[UIImage imageNamed:@"iconfont_feng"],
                                      @"FOG":[UIImage imageNamed:@"iconfont_my_wu"],
                                      @"HAZE":[UIImage imageNamed:@"iconfont_mai"]};
    return weatherImageDic[weatherValue];
}

- (NSString *)getWeatherValueNameFromWeatherValue:(NSString *)weatherValue
{
    NSDictionary *weatherValueDic = @{@"CLEAR_DAY":@"晴天",
                                      @"CLEAR_NIGHT":@"晴夜",
                                      @"PARTLY_CLOUDY_DAY":@"多云",
                                      @"PARTLY_CLOUDY_NIGHT":@"多云",
                                      @"CLOUDY":@"阴",
                                      @"RAIN":@"雨",
                                      @"SLEET":@"冻雨",
                                      @"SNOW":@"雪",
                                      @"WIND":@"风",
                                      @"FOG":@"雾",
                                      @"HAZE":@"霾"};
    return weatherValueDic[weatherValue];
}

- (NSString *)getAirQualityFromPm25:(CGFloat)pm25
{
    if (pm25>=0 && pm25<=35) {
        return @"优";
    }
    if (pm25>35 && pm25<=75) {
        return @"良";
    }
    if (pm25>75 && pm25<=115) {
        return @"轻度污染";
    }
    if (pm25>115 && pm25<=150) {
        return @"中度污染";
    }
    if (pm25>150 && pm25<=250) {
        return @"重度污染";
    }
    if (pm25>250) {
        return @"严重污染";
    }
    return @"";
}

@end

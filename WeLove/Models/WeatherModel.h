//
//  WeatherModel.h
//  ant
//
//  Created by KevinCao on 16/8/17.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property(nonatomic,copy)NSString *weatherValue;
@property(nonatomic,copy)NSString *weatherValueName;
@property(nonatomic,copy)NSString *airQuality;
@property(nonatomic,copy)NSDate *date;
@property(nonatomic,copy)NSNumber *maxTemp;
@property(nonatomic,copy)NSNumber *minTemp;
@property(nonatomic,copy)NSNumber *avgTemp;
@property(nonatomic,copy)NSNumber *maxPm25;
@property(nonatomic,copy)NSNumber *minPm25;
@property(nonatomic,copy)NSNumber *avgPm25;
@property(nonatomic,copy)UIImage *weatherImage;
@property(nonatomic,copy)NSArray *weatherTimeList;
@end

@interface WeatherTimeLineModel : NSObject
@property(nonatomic,copy)NSString *weatherValue;
@property(nonatomic,copy)NSString *weatherValueName;
@property(nonatomic,copy)NSDate *time;
@property(nonatomic,copy)NSString *timeValue;
@property(nonatomic,copy)NSNumber *avgTemp;
@property(nonatomic,copy)UIImage *weatherImage;
@end

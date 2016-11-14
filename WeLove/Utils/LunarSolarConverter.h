//
//  LunarSolarConverter.h
//  inongtian
//
//  Created by KevinCao on 2016/10/24.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lunar : NSObject
/**
 *是否闰月
 */
@property(assign) BOOL isleap;
/**
 *农历 日
 */
@property(assign) int lunarDay;
/**
 *农历 月
 */
@property(assign) int lunarMonth;
/**
 *农历 年
 */
@property(assign) int lunarYear;
/**
 *农历 中文日
 */
@property(assign) NSString *chineseLunarDay;
/**
 *农历 中文月
 */
@property(assign) NSString *chineseLunarMonth;

@end

@interface Solar : NSObject
/**
 *公历 日
 */
@property(assign) int solarDay;
/**
 *公历 月
 */
@property(assign) int solarMonth;
/**
 *公历 年
 */
@property(assign) int solarYear;

@end

@interface LunarSolarConverter : NSObject

/**
 *农历转公历
 */
+ (Solar *)lunarToSolar:(Lunar *)lunar;

/**
 *公历转农历
 */
+ (Lunar *)solarToLunar:(Solar *)solar;
/**
 *公历日期转农历
 */
+ (Lunar *)dateToLunar:(NSDate *)date;

@end

//
//  WeatherSensorManager.h
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseAPIManager.h"

@interface WeatherSensorManager : BaseAPIManager <APIManager>
@property(nonatomic,copy)NSArray *weatherSensorList;
@end

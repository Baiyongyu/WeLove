//
//  WaterSensorManager.h
//  ant
//
//  Created by KevinCao on 16/8/23.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseAPIManager.h"

@interface WaterSensorManager : BaseAPIManager <APIManager>
@property(nonatomic,copy)NSArray *waterSensorList;
@end

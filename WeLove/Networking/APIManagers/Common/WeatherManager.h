//
//  WeatherManager.h
//  ant
//
//  Created by KevinCao on 16/8/16.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseAPIManager.h"

@interface WeatherManager : BaseAPIManager<APIManager>
@property(nonatomic,retain)NSMutableArray *weatherList;
@end

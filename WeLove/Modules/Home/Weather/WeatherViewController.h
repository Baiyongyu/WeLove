//
//  WeatherViewController.h
//  ant
//
//  Created by KevinCao on 16/8/17.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANTBaseViewController.h"

@interface WeatherViewController : ANTBaseViewController
@end

@interface WeatherHeaderView : UIView
@property(nonatomic,retain)WeatherModel *weatherData;
@end

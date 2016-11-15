//
//  WeatherViewController.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "BaseViewController.h"

@interface WeatherViewController : BaseViewController
@end

@interface WeatherHeaderView : UIView
@property(nonatomic,retain)WeatherModel *weatherData;
@end

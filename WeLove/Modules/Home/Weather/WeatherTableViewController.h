//
//  WeatherTableViewController.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "BaseTableViewController.h"

@interface WeatherTableViewController : BaseTableViewController

@end

@interface WeatherTableHeaderView : UITableViewHeaderFooterView
@property(nonatomic,assign)BOOL shouldHiddenWeatherImage;
@property(nonatomic,retain)WeatherModel *weatherData;
@end

@interface WeatherTableFooterView : UITableViewHeaderFooterView
@property(nonatomic,retain)NSArray *weatherTimeList;
@end

@interface WeatherTimeLineCell : UITableViewCell
@property(nonatomic,retain)WeatherTimeLineModel *weatherTimeLineData;
@end

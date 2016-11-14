//
//  WeatherTableViewController.h
//  ant
//
//  Created by KevinCao on 16/8/17.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANTBaseTableViewController.h"

@interface WeatherTableViewController : ANTBaseTableViewController

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

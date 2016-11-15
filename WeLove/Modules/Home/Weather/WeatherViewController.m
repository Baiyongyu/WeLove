//
//  WeatherViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherManager.h"
#import "WeatherTableViewController.h"

@interface WeatherViewController ()
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)WeatherTableViewController *weatherTableVC;
@property(nonatomic,strong)WeatherHeaderView *headerView;
@property(nonatomic,strong)WeatherManager *weatherManager;
@end

@implementation WeatherViewController

- (void)loadSubViews
{
    [super loadSubViews];
    self.leftBtn.hidden = NO;
    self.titleLabel.text = @"天气";
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.weatherTableVC.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated) name:kLocationUpdatedSuccessNotification object:nil];
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [self.weatherTableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bgView);
    }];
    
    self.headerView.height = 220;
    self.weatherTableVC.tableView.tableHeaderView = self.headerView;
}

- (void)loadData
{
    if (!locationManager.userLocation.location) {
        [locationManager startLocation];
    }
    [self.weatherManager loadDataWithHUDOnView:self.contentView];
}

#pragma mark - notes
-(void)locationUpdated
{
    [self.weatherManager loadDataWithHUDOnView:self.contentView];
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(BaseAPIManager *)manager
{
    if (manager==self.weatherManager) {
        return @{@"longitude":@(locationManager.longitude),
                 @"latitude":@(locationManager.latitude)};
    }
    return nil;
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager
{
    if (self.weatherManager.weatherList.count) {
        WeatherModel *todayWeatherData = self.weatherManager.weatherList[0];
        self.bgView.image = [self getWeatherBgImageFromWeatherValue:todayWeatherData.weatherValue];
        self.headerView.weatherData = todayWeatherData;
        self.weatherTableVC.dataArray = self.weatherManager.weatherList;
    }
}

- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager
{
    [MBProgressHUD showTip:manager.errorMessage];
}

#pragma mark - private
- (UIImage *)getWeatherBgImageFromWeatherValue:(NSString *)weatherValue
{
    NSDictionary *weatherBgImageDic = @{@"CLEAR_DAY":[UIImage imageNamed:@"bg_weather_qing.jpg"],
                                        @"CLEAR_NIGHT":[UIImage imageNamed:@"bg_weather_qingye.jpg"],
                                        @"PARTLY_CLOUDY_DAY":[UIImage imageNamed:@"bg_weather_duoyun.jpg"],
                                        @"PARTLY_CLOUDY_NIGHT":[UIImage imageNamed:@"bg_weather_duoyunye.jpg"],
                                        @"CLOUDY":[UIImage imageNamed:@"bg_weather_yin.jpg"],
                                        @"RAIN":[UIImage imageNamed:@"bg_weather_yu.jpg"],
                                        @"SLEET":[UIImage imageNamed:@"bg_weather_dongyu.jpg"],
                                        @"SNOW":[UIImage imageNamed:@"bg_weather_xue.jpg"],
                                        @"WIND":[UIImage imageNamed:@"bg_weather_feng.jpg"],
                                        @"FOG":[UIImage imageNamed:@"bg_weather_wu.jpg"],
                                        @"HAZE":[UIImage imageNamed:@"bg_weather_mai.jpg"]};
    return weatherBgImageDic[weatherValue];
}

#pragma mark - getters and setters
-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

-(WeatherHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WeatherHeaderView alloc] init];
    }
    return _headerView;
}

-(WeatherTableViewController *)weatherTableVC
{
    if (!_weatherTableVC) {
        _weatherTableVC = [[WeatherTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _weatherTableVC;
}

-(WeatherManager *)weatherManager
{
    if (!_weatherManager) {
        _weatherManager = [[WeatherManager alloc] init];
        _weatherManager.paramSource = (id)self;
        _weatherManager.delegate = (id)self;
        _weatherManager.validator = (id)_weatherManager;
    }
    return _weatherManager;
}

@end

@interface WeatherHeaderView ()
@property(nonatomic,strong)UIImageView *weatherImageView;
@property(nonatomic,strong)UILabel *weatherValueLabel;
@property(nonatomic,strong)UILabel *temperatureLabel;
@end

@implementation WeatherHeaderView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.weatherImageView];
        [self addSubview:self.weatherValueLabel];
        [self addSubview:self.temperatureLabel];
        [self layoutConstraints];
    }
    return self;
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(40);
        make.centerX.equalTo(weakSelf);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.weatherValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.weatherImageView.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(weakSelf);
    }];
    
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.weatherValueLabel.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(weakSelf);
    }];
}

#pragma mark - getters and setters
-(void)setWeatherData:(WeatherModel *)weatherData
{
    _weatherData = weatherData;
    self.weatherImageView.image = _weatherData.weatherImage;
    self.weatherValueLabel.text = _weatherData.weatherValueName;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.2f˚",_weatherData.avgTemp.doubleValue];
}

-(UIImageView *)weatherImageView
{
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] init];
        _weatherImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _weatherImageView;
}

-(UILabel *)weatherValueLabel
{
    if (!_weatherValueLabel) {
        _weatherValueLabel = [[UILabel alloc] init];
        _weatherValueLabel.font = XiHeiFont(20);
        _weatherValueLabel.textColor = [UIColor whiteColor];
        _weatherValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weatherValueLabel;
}

-(UILabel *)temperatureLabel
{
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] init];
        _temperatureLabel.font = [UIFont boldSystemFontOfSize:34];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _temperatureLabel;
}

@end

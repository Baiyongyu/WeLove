//
//  HomeWeatherView.m
//  inongtian
//
//  Created by KevinCao on 2016/10/24.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "HomeWeatherView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "WeatherManager.h"
#import "LunarSolarConverter.h"

@interface HomeWeatherView ()
//背景图片
@property(nonatomic,strong)UIImageView *bgView;
//定位按钮
@property(nonatomic,strong)QMButton *locationBtn;
//天气icon
@property(nonatomic,strong)UIImageView *weatherImageView;
//温度
@property(nonatomic,strong)UILabel *temperatureLabel;
//天气
@property(nonatomic,strong)UILabel *weatherLabel;
//日期
@property(nonatomic,strong)UILabel *dateLabel;
//农历
@property(nonatomic,strong)UILabel *lunarDateLabel;
//空气质量
@property(nonatomic,strong)UILabel *airQualityLabel;
//天气API
@property(nonatomic,strong)WeatherManager *weatherManager;
@end

@implementation HomeWeatherView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kDefaultViewBackgroundColor;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.locationBtn];
        [self.bgView addSubview:self.weatherImageView];
        [self.bgView addSubview:self.temperatureLabel];
        [self.bgView addSubview:self.weatherLabel];
        [self.bgView addSubview:self.dateLabel];
        [self.bgView addSubview:self.lunarDateLabel];
        [self.bgView addSubview:self.airQualityLabel];
        [self layoutConstraints];
        [self loadData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated) name:kLocationUpdatedSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailed) name:kLocationFailedNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutConstraints
{
    WS(weakSelf);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).offset(20);
        make.top.equalTo(weakSelf.bgView).offset(30);
        make.height.mas_equalTo(54);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView).offset(-85);
        make.top.equalTo(weakSelf.bgView).offset(30);
        make.width.height.mas_equalTo(45);
    }];
    
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.weatherImageView.mas_right).offset(10);
        make.top.equalTo(weakSelf.weatherImageView);
        make.height.mas_equalTo(25);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.weatherImageView.mas_right).offset(10);
        make.bottom.equalTo(weakSelf.weatherImageView);
        make.height.mas_equalTo(18);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.lunarDateLabel.mas_top).offset(-5);
        make.left.equalTo(weakSelf.bgView).offset(20);
        make.height.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    [self.lunarDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.bgView).offset(-25);
        make.left.equalTo(weakSelf.bgView).offset(20);
        make.height.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    [self.airQualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgView).offset(-25);
        make.right.equalTo(weakSelf.bgView).offset(-25);
        make.height.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
}

-(void)loadData
{
    [self updateLocation];
    [self updateDate];
}

-(void)updateLocation
{
    if (!locationManager.userLocation.location) {
        self.locationBtn.hidden = YES;
        return;
    }
    [locationManager geoSearchNearbyWithDelegate:self coordinate:locationManager.coordinate];
    [self.weatherManager loadDataWithHUDOnView:nil];
}

-(void)locationFailed
{
    [self.weatherManager loadDataWithHUDOnView:nil];
}

-(void)updateDate
{
    self.dateLabel.text = [QMUtil formatter:@"yyyy/MM/dd EEEE" fromeDate:[NSDate date]];
    Lunar *lunar = [LunarSolarConverter dateToLunar:[NSDate date]];
    self.lunarDateLabel.text = [NSString stringWithFormat:@"农历%@%@",lunar.chineseLunarMonth,lunar.chineseLunarDay];
}


#pragma mark - GEO search
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.locationBtn.hidden = NO;
        NSString *city = [QMUtil checkString:result.addressDetail.city];
        NSString *district = [QMUtil checkString:result.addressDetail.district];
        NSString *address = [NSString stringWithFormat:@"%@·%@",city,district];
        [self.locationBtn setTitle:address forState:UIControlStateNormal];
        CGSize locationSize = [QMUtil getSizeWithText:address font:XiHeiFont(14)];
        self.locationBtn.imageViewFrame = CGRectMake((locationSize.width-20)/2.0, 0, 20, 23);
        self.locationBtn.titleLabelFrame = CGRectMake(0, 34, locationSize.width, 15);
    }
    else {
        //未找到结果
    }
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
        WeatherModel *weatherData = self.weatherManager.weatherList[0];
        self.weatherImageView.image = weatherData.weatherImage;
        self.temperatureLabel.text = [NSString stringWithFormat:@"%d°",[weatherData.avgTemp intValue]];
        self.weatherLabel.text = weatherData.weatherValueName;
        self.airQualityLabel.text = [NSString stringWithFormat:@"空气质量：%@",weatherData.airQuality];
    }
}

- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager
{
//    [MBProgressHUD showTip:manager.errorMessage];
}

#pragma mark - notes
-(void)locationUpdated
{
    [self updateLocation];
}

#pragma mark - getters and setters
-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgView.layer.masksToBounds = YES;
//        _bgView.image = [UIImage imageNamed:@"ic_weather_bg"];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

-(QMButton *)locationBtn
{
    if (!_locationBtn) {
        _locationBtn = [QMButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"ic_location"] forState:UIControlStateNormal];
        _locationBtn.titleLabel.font = XiHeiFont(14);
        _locationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _locationBtn.enabled = NO;
        _locationBtn.relayout = YES;
    }
    return _locationBtn;
}

-(UIImageView *)weatherImageView
{
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] init];
        _weatherImageView.layer.masksToBounds = YES;
        _weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _weatherImageView;
}

-(UILabel *)temperatureLabel
{
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] init];
        _temperatureLabel.font = XiHeiFont(25);
        _temperatureLabel.textColor = [UIColor whiteColor];
    }
    return _temperatureLabel;
}

-(UILabel *)weatherLabel
{
    if (!_weatherLabel) {
        _weatherLabel = [[UILabel alloc] init];
        _weatherLabel.font = XiHeiFont(18);
        _weatherLabel.textColor = [UIColor whiteColor];
    }
    return _weatherLabel;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = XiHeiFont(14);
        _dateLabel.textColor = [UIColor whiteColor];
    }
    return _dateLabel;
}

-(UILabel *)lunarDateLabel
{
    if (!_lunarDateLabel) {
        _lunarDateLabel = [[UILabel alloc] init];
        _lunarDateLabel.font = XiHeiFont(14);
        _lunarDateLabel.textColor = [UIColor whiteColor];
    }
    return _lunarDateLabel;
}

-(UILabel *)airQualityLabel
{
    if (!_airQualityLabel) {
        _airQualityLabel = [[UILabel alloc] init];
        _airQualityLabel.font = XiHeiFont(16);
        _airQualityLabel.textColor = [UIColor whiteColor];
        _airQualityLabel.textAlignment = NSTextAlignmentRight;
    }
    return _airQualityLabel;
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

//
//  WeatherTableViewController.m
//  ant
//
//  Created by KevinCao on 16/8/17.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "WeatherTableViewController.h"

@implementation WeatherTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!section) {
        return 140;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *identifier = @"weatherHeader";
    WeatherTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[WeatherTableHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    headerView.weatherData = self.dataArray[section];
    headerView.shouldHiddenWeatherImage = !section;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section) {
        return nil;
    }
    NSString *identifier = @"weatherFooter";
    WeatherTableFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView) {
        footerView = [[WeatherTableFooterView alloc] initWithReuseIdentifier:identifier];
    }
    WeatherModel *weatherData = self.dataArray[section];
    footerView.weatherTimeList = weatherData.weatherTimeList;
    return footerView;
}

@end

@interface WeatherTableHeaderView ()
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIImageView *weatherImageView;
@property(nonatomic,strong)UILabel *maxTempLabel;
@property(nonatomic,strong)UILabel *minTempLabel;
@end

@implementation WeatherTableHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.weatherImageView];
        [self.contentView addSubview:self.maxTempLabel];
        [self.contentView addSubview:self.minTempLabel];
        [self layoutConstraints];
    }
    return self;
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
        make.top.bottom.equalTo(weakSelf.contentView);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).multipliedBy(0.5);
        make.top.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(40);
    }];
    
    [self.maxTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.minTempLabel.mas_left).offset(-20);
        make.top.bottom.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(60);
    }];
    
    [self.minTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-15);
        make.top.bottom.width.equalTo(weakSelf.maxTempLabel);
    }];
}

#pragma mark - getters and setters
-(void)setWeatherData:(WeatherModel *)weatherData
{
    _weatherData = weatherData;
    self.dateLabel.text = [QMUtil formatter:@"EEEE" fromeDate:_weatherData.date];
    self.weatherImageView.image = _weatherData.weatherImage;
    self.maxTempLabel.text = [NSString stringWithFormat:@"%.2f˚",_weatherData.maxTemp.doubleValue];
    self.minTempLabel.text = [NSString stringWithFormat:@"%.2f˚",_weatherData.minTemp.doubleValue];
}

-(void)setShouldHiddenWeatherImage:(BOOL)shouldHiddenWeatherImage
{
    _shouldHiddenWeatherImage = shouldHiddenWeatherImage;
    self.weatherImageView.hidden = _shouldHiddenWeatherImage;
}

-(UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = XiHeiFont(16);
        _dateLabel.textColor = [UIColor whiteColor];
    }
    return _dateLabel;
}

-(UIImageView *)weatherImageView
{
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] init];
        _weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _weatherImageView;
}

-(UILabel *)maxTempLabel
{
    if (!_maxTempLabel) {
        _maxTempLabel = [[UILabel alloc] init];
        _maxTempLabel.font = XiHeiFont(16);
        _maxTempLabel.textColor = [UIColor whiteColor];
        _maxTempLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxTempLabel;
}

-(UILabel *)minTempLabel
{
    if (!_minTempLabel) {
        _minTempLabel = [[UILabel alloc] init];
        _minTempLabel.font = XiHeiFont(16);
        _minTempLabel.textColor = [UIColor whiteColor];
        _minTempLabel.textAlignment = NSTextAlignmentRight;
    }
    return _minTempLabel;
}

@end

@interface WeatherTableFooterView () <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *timeLineTableView;
@property(nonatomic,strong)UIView *topLine;
@property(nonatomic,strong)UIView *bottomLine;
@end

@implementation WeatherTableFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timeLineTableView];
        [self.contentView addSubview:self.topLine];
        [self.contentView addSubview:self.bottomLine];
        [self layoutConstraints];
    }
    return self;
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.timeLineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(weakSelf.mas_height);
        make.height.mas_equalTo(weakSelf.mas_width);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weatherTimeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"weatherTimeLineCell";
    WeatherTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WeatherTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    cell.weatherTimeLineData = self.weatherTimeList[indexPath.row];
    return cell;
}

#pragma mark - getters and setters
-(void)setWeatherTimeList:(NSArray *)weatherTimeList
{
    _weatherTimeList = weatherTimeList;
    [_timeLineTableView reloadData];
}

-(UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _topLine;
}

-(UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _bottomLine;
}

-(UITableView *)timeLineTableView
{
    if (!_timeLineTableView) {
        _timeLineTableView = [[UITableView alloc] init];
        _timeLineTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        _timeLineTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _timeLineTableView.dataSource = self;
        _timeLineTableView.delegate = self;
        _timeLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _timeLineTableView.backgroundColor = [UIColor clearColor];
        _timeLineTableView.rowHeight = 70;
        _timeLineTableView.showsVerticalScrollIndicator = NO;
    }
    return _timeLineTableView;
}

@end

@interface WeatherTimeLineCell ()
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *weatherImageView;
@property(nonatomic,strong)UILabel *temperatureLabel;
@end

@implementation WeatherTimeLineCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.weatherImageView];
        [self.contentView addSubview:self.temperatureLabel];
        [self layoutConstraints];
    }
    return self;
}

-(void)layoutConstraints
{
    WS(weakSelf);
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(30);
    }];
    
    [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - getters and setters
-(void)setWeatherTimeLineData:(WeatherTimeLineModel *)weatherTimeLineData
{
    _weatherTimeLineData = weatherTimeLineData;
    self.timeLabel.text = _weatherTimeLineData.timeValue;
    self.weatherImageView.image = _weatherTimeLineData.weatherImage;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.2f˚",_weatherTimeLineData.avgTemp.doubleValue];
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = XiHeiFont(16);
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

-(UIImageView *)weatherImageView
{
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] init];
        _weatherImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _weatherImageView;
}

-(UILabel *)temperatureLabel
{
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] init];
        _temperatureLabel.font = XiHeiFont(16);
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _temperatureLabel;
}

@end

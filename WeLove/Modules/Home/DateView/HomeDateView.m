//
//  HomeWeatherView.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "HomeDateView.h"
#import "LunarSolarConverter.h"

@interface HomeDateView ()
//背景图片
@property(nonatomic,strong)UIImageView *bgView;
//日期
@property(nonatomic,strong)UILabel *dateLabel;
//农历
@property(nonatomic,strong)UILabel *lunarDateLabel;
@end

@implementation HomeDateView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.dateLabel];
        [self.bgView addSubview:self.lunarDateLabel];
        [self layoutConstraints];
        [self updateDate];

    }
    return self;
}


-(void)layoutConstraints
{
    WS(weakSelf);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];

    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.lunarDateLabel.mas_top).offset(-10);
        make.right.equalTo(weakSelf.bgView).offset(-10);
        make.height.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    
    [self.lunarDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.bgView).offset(-25);
        make.right.equalTo(weakSelf.bgView).offset(-10);
        make.height.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
}

-(void)updateDate
{
    self.dateLabel.text = [QMUtil formatter:@"yyyy/MM/dd EEEE" fromeDate:[NSDate date]];
    Lunar *lunar = [LunarSolarConverter dateToLunar:[NSDate date]];
    self.lunarDateLabel.text = [NSString stringWithFormat:@"农历%@%@",lunar.chineseLunarMonth,lunar.chineseLunarDay];
}

#pragma mark - getters and setters
-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgView.layer.masksToBounds = YES;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
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


@end

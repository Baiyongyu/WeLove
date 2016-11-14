//
//  ProgressBar.m
//  ant
//
//  Created by KevinCao on 16/8/23.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ProgressBar.h"

@interface ProgressBar ()
@property(nonatomic,strong)UIView *barBgView;
@property(nonatomic,strong)UIView *barView;
@property(nonatomic,strong)UILabel *valueLabel;
@property(nonatomic,assign)CGFloat currentProgress;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation ProgressBar

-(void)dealloc
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.barBgView];
        [self addSubview:self.valueLabel];
        [self.barBgView addSubview:self.barView];
        [self layoutConstraints];
    }
    return self;
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.barBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf).offset(-50);
    }];
    
    [self.valueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(weakSelf);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
}

-(void)updateConstraints
{
    WS(weakSelf);
    
    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.barBgView);
        make.width.equalTo(weakSelf.barBgView).multipliedBy((weakSelf.currentProgress-weakSelf.minValue)/(weakSelf.maxValue-weakSelf.minValue));
    }];
    
    [super updateConstraints];
}

- (void)start
{
    if (self.disableTimer) {
        self.valueLabel.text = [QMUtil stringDisposeWithDouble:self.progressValue];
        self.currentProgress = self.progressValue;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)stop
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self.timer invalidate];
}

- (void)updateProgress
{
    if (self.progressValue >= self.maxValue) {
        self.valueLabel.text = [QMUtil stringDisposeWithDouble:self.progressValue];
        _currentProgress = self.maxValue;
        [self stop];
        return;
    }
    self.valueLabel.text = [QMUtil stringDisposeWithDouble:(double)_currentProgress];
    if (self.progressValue == 0) {
        [self stop];
        return;
    }else if (_currentProgress >= self.maxValue || _currentProgress >= self.progressValue){
        [self stop];
        return;
    }
    //update progress value
    if (_currentProgress+(self.maxValue-self.minValue)/50 > self.progressValue) {
        _currentProgress = self.progressValue;
    } else {
        _currentProgress = _currentProgress+(self.maxValue-self.minValue)/50;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - getters and setters
-(void)setProgressValue:(float)progressValue
{
    _progressValue = progressValue;
    _currentProgress = 0;
    [self stop];
    [self start];
}

-(void)setAlertStatus:(BOOL)alertStatus
{
    if (alertStatus) {
        self.barView.backgroundColor = [UIColor redColor];
    } else {
        self.barView.backgroundColor = self.barColor?:kGreenColor;
    }
}

-(void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.barView.backgroundColor = barColor;
}

-(void)setBarBackgroundColor:(UIColor *)barBackgroundColor
{
    _barBackgroundColor = barBackgroundColor;
    self.barBgView.backgroundColor = barBackgroundColor;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.valueLabel.textColor = textColor;
}

-(UIView *)barBgView
{
    if (!_barBgView) {
        _barBgView = [[UIView alloc] init];
        _barBgView.backgroundColor = kBgLightGrayColor;
        _barBgView.clipsToBounds = YES;
        _barBgView.layer.cornerRadius = 2;
    }
    return _barBgView;
}

-(UIView *)barView
{
    if (!_barView) {
        _barView = [[UIView alloc] init];
        _barView.backgroundColor = kGreenColor;
    }
    return _barView;
}

-(UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = XiHeiFont(16);
        _valueLabel.textColor = kGreenColor;
    }
    return _valueLabel;
}

@end

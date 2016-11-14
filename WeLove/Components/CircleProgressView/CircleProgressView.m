//
//  CircleProgressView.m
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleProgressView ()
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *titleLabel;
//当前进度
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic) NSTimer *timer;
@end

@implementation CircleProgressView

-(void)dealloc {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width/2.0;
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , self.height/2.0, self.width-20, 20)];
    self.valueLabel.font = XiHeiFont(14);
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.valueLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , self.height/2.0-20, self.width-20, 20)];
    self.titleLabel.font = XiHeiFont(14);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    self.circleWidth = 2;
    self.maxValue = 100.0;
    self.unfinishColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.finishColor = kGreenColor;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.valueLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize-8];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.valueLabel.textColor = textColor;
    self.titleLabel.textColor = textColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setProgressValue:(float)progressValue {
    _progressValue = progressValue;
    if (self.openAlert) {
        if ((_progressValue>self.maxAlertValue) || (_progressValue<self.minAlertValue)) {
            self.finishColor = [UIColor redColor];
        } else {
            self.finishColor = kGreenColor;
        }
    }
    [self stop];
    _currentProgress = 0;
    [self start];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawBackgroundCircle];
    [self drawProgressCircle];
}

//背景圆环
- (void)drawBackgroundCircle {
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)
                                                              radius:(CGRectGetWidth(self.bounds)-self.circleWidth) / 2
                                                          startAngle:(CGFloat) - M_PI_2
                                                            endAngle:(CGFloat)(1.5 * M_PI)
                                                           clockwise:YES];
    [self.unfinishColor setStroke];
    backCircle.lineWidth = self.circleWidth;
    [backCircle stroke];
}

//进度圆环
- (void)drawProgressCircle {
    if (self.progressValue) {
        //draw progress circle
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                                      radius:(CGRectGetWidth(self.bounds) - self.circleWidth) / 2
                                                                  startAngle:(CGFloat) - M_PI_2
                                                                    endAngle:(CGFloat)(- M_PI_2 + (float)(self.currentProgress-self.minValue*10)/(float)((self.maxValue -self.minValue)* 10) * 2 * M_PI)
                                                                   clockwise:YES];
        [self.finishColor setStroke];
        progressCircle.lineWidth = self.circleWidth;
        [progressCircle stroke];
    }
}

//启动
- (void)start {
    if (self.disableTimer) {
        self.valueLabel.text = [QMUtil stringDisposeWithDouble:self.progressValue];
        self.currentProgress = self.progressValue*10;
        [self drawProgressCircle];
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(updateProgressCircle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

//暂停
- (void)stop {
    [self.timer invalidate];
}

- (void)updateProgressCircle{
    //redraw back & progress circles
    [self setNeedsDisplay];
    if (self.progressValue >= self.maxValue) {
        [self setValueForValueLabel:[QMUtil stringDisposeWithDouble:self.progressValue]];
        _currentProgress = self.maxValue*10;
        [self stop];
        return;
    }
    [self setValueForValueLabel:[QMUtil stringDisposeWithDouble:(double)_currentProgress/10.0]];
    if (self.progressValue == 0) {
        [self stop];
        return;
    }else if (_currentProgress == (int)(self.maxValue*10) || _currentProgress == roundf(self.progressValue*10)){
        [self stop];
        return;
    }
    //update progress value
    if (_currentProgress+(self.maxValue-self.minValue)/5 > self.progressValue*10) {
        _currentProgress = self.progressValue*10;
    } else {
        _currentProgress = _currentProgress+(self.maxValue-self.minValue)/5;
    }
}

- (void)setValueForValueLabel:(NSString *)value
{
    if (!self.displayValue.length || self.displayValue.floatValue) {
        self.valueLabel.text = value;
    } else {
        self.valueLabel.text = self.displayValue;
    }
}

@end


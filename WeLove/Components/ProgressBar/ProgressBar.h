//
//  ProgressBar.h
//  ant
//
//  Created by KevinCao on 16/8/23.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBar : UIView
//进度条背景颜色
@property (nonatomic, strong) UIColor *barBackgroundColor;
//进度条颜色
@property (nonatomic, strong) UIColor *barColor;
//文字颜色
@property (nonatomic, strong) UIColor *textColor;
//最小值
@property (nonatomic, assign) float minValue;
//最大值
@property (nonatomic, assign) float maxValue;
//进度值
@property (nonatomic, assign) float progressValue;
//是否警戒
@property (nonatomic, assign) BOOL alertStatus;
//定时器开关
@property (nonatomic, assign) BOOL disableTimer;

@end

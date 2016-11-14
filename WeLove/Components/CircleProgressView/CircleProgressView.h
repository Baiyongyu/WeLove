//
//  CircleProgressView.h
//  ant
//
//  Created by KevinCao on 16/8/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

//圆环颜色
@property (nonatomic, strong) UIColor *finishColor;
@property (nonatomic, strong) UIColor *unfinishColor;
//文字颜色
@property (nonatomic, strong) UIColor *textColor;
//字体
@property (nonatomic, assign) CGFloat fontSize;
//圆环宽度
@property (nonatomic, assign) float circleWidth;
//最小值
@property (nonatomic, assign) float minValue;
//最大值
@property (nonatomic, assign) float maxValue;
//最小警戒值
@property (nonatomic, assign) float minAlertValue;
//最大警戒值
@property (nonatomic, assign) float maxAlertValue;
//进度值
@property (nonatomic, assign) float progressValue;
//显示值
@property (nonatomic, copy) NSString *displayValue;
//标题
@property (nonatomic, copy) NSString *title;
//定时器开关
@property (nonatomic, assign) BOOL disableTimer;
//开启警戒值
@property (nonatomic, assign) BOOL openAlert;

@end

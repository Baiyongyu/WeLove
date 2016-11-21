//
//  RotatingView.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/16.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotatingView : UIView

@property (nonatomic, strong) UIImageView *imageView;

- (void)setRotatingViewLayoutWithFrame:(CGRect)frame;

// 添加动画
- (void)addAnimation;
// 停止
- (void)pauseLayer;
// 恢复
- (void)resumeLayer;
// 移除动画
- (void)removeAnimation;

@end

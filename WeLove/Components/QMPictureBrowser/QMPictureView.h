//
//  QMPictureView.h
//  inongtian
//
//  Created by KevinCao on 2016/10/26.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QMPictureView;
@protocol QMPictureViewDelegate <NSObject>

- (void)pictureViewTouch:(QMPictureView *)pictureView;

- (void)pictureView:(QMPictureView *)pictureView scale:(CGFloat)scale;

@end

@interface QMPictureView : UIScrollView

// 当前视图所在的索引
@property (nonatomic, assign) NSInteger index;
// 图片的大小
@property (nonatomic, assign) CGSize pictureSize;
// 显示的默认图片
@property (nonatomic, strong) UIImage *placeholderImage;
// 图片的地址 URL
@property (nonatomic, strong) NSString *urlString;
// 当前显示图片的控件
@property (nonatomic, strong, readonly) UIImageView *imageView;
// 代理
@property (nonatomic, weak) id<QMPictureViewDelegate> pictureDelegate;

/**
 动画显示
 
 @param rect            从哪个位置开始做动画
 @param animationBlock  附带的动画信息
 @param completionBlock 结束的回调
 */
- (void)animationShowWithFromRect:(CGRect)rect animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;


/**
 动画消失
 
 @param rect            回到哪个位置
 @param animationBlock  附带的动画信息
 @param completionBlock 结束的回调
 */
- (void)animationDismissWithToRect:(CGRect)rect animationBlock:(void(^)())animationBlock completionBlock:(void(^)())completionBlock;

@end

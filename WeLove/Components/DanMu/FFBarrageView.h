//
//  FFBarrageView.h
//  FFBarrageDemo
//
//  Created by Fan on 16/10/31.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 弹幕的状态

 - Start: 弹幕还未进入屏幕前
 - Enter: 完全进入屏幕
 - End:   弹幕移除屏幕
 */
typedef NS_ENUM(NSInteger, MoveStatus) {
    Start,
    Enter,
    End
};

@interface FFBarrageView : UIView


/**
 *  当前弹幕显示在第几个轨道上
 */
@property(nonatomic, assign) NSInteger trajectory;

/**
 *  弹幕状态回调，弹幕开始（弹幕还未进入屏幕前），弹幕中（完全进入屏幕），弹幕结束（弹幕移除屏幕）
 */
@property(nonatomic, copy) void(^moveStatusBlock)(MoveStatus status);

/**
 初始化弹幕

 @param comment 弹幕内容，后期可根据需要扩充弹幕内容，如头像

 @return 返回FFBarrageView对象
 */
- (instancetype)initWithComment:(NSString *)comment;


/**
 *   弹幕开始滚动动画
 */
- (void)startAnimation;


/**
 *  停止动画
 */
- (void)stopAnimation;

@end

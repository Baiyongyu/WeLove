//
//  FFBarrageManager.h
//  FFBarrageDemo
//
//  Created by Fan on 16/10/31.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FFBarrageView;

/**
 *  弹幕管理类，管理弹幕的一些设置，开始、结束等
 *
 */
@interface FFBarrageManager : NSObject


/**
 *  弹幕轨道的个数
 */
@property(nonatomic) NSInteger trajectoryCount;


/**
 * 弹幕与弹幕间的间隔
 */
@property(nonatomic) NSInteger trajectoryPadding;

/**
 *  回调FFBarrageView对象，可以对该对象进行一些处理
 */
@property(nonatomic, copy) void (^generateViewBlock)(FFBarrageView *view);

/**
 创建弹幕管理类，并且进行初始化设置

 @param comments 传入评论的内容数组

 @return FFBarrageView对象
 */
- (instancetype)initWithComments:(NSArray *)comments;


/**
 当有新的数据来时，进行追加

 @param data NSArray
 */
- (void)appendData:(NSArray *)data;

/**
 *  弹幕开始
 *
 */
- (void)start;

/**
 *  弹幕停止
 *
 */
- (void)stop;
@end

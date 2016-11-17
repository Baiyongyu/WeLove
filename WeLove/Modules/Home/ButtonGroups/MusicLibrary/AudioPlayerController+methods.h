//
//  AudioPlayerController+methods.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/16.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "AudioPlayerController.h"

@interface AudioPlayerController (methods)
/**
 *  创建部分控件
 */
- (void)creatViews;

/**
 *  设置旋转图的Frame
 */
- (void)setRotatingViewFrame;

/**
 *  设置旋转图片、模糊图片
 *
 *  @param model 当前的音乐model
 */
- (void)setImageWith:(MusicModel *)model;

/**
 *  提示框
 *
 *  @param string 提示字符串
 */
- (void)progressHUDWith:(NSString *)string;

@end

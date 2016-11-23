//
//  FarmActivityModel.h
//  ant
//
//  Created by KevinCao on 16/8/16.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HappyTimeModel : NSObject

// 时间
@property(nonatomic,copy)NSString *time;
// 标题
@property(nonatomic,copy)NSString *titleName;
// 详情
@property(nonatomic,copy)NSString *detailInfo;
// 图片视频数组
@property(nonatomic,copy)NSArray *pictureArray;
// 内容高度
@property(nonatomic,assign)CGFloat contentHeight;

+ (instancetype)homeModelWithDict:(NSDictionary *)dict;

@end



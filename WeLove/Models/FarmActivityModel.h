//
//  FarmActivityModel.h
//  ant
//
//  Created by KevinCao on 16/8/16.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FarmActivityModel : NSObject
//活动id
@property(nonatomic,copy)NSString *activityId;
//时间
@property(nonatomic,copy)NSString *activityTime;
//活动名称
@property(nonatomic,copy)NSString *activityName;
//活动详情
@property(nonatomic,copy)NSString *activityDetailInfo;
@property(nonatomic,copy)NSString *imageUrl;
//图片视频数组
@property(nonatomic,copy)NSArray *pictureArray;
//活动时间
@property(nonatomic,copy)NSDate *activityDate;
//活动主体
@property(nonatomic,copy)NSString *activityPerson;
//田块数组
@property(nonatomic,copy)NSArray *fields;
//投入量
@property(nonatomic,copy)NSString *activityInput;
//内容高度
@property(nonatomic,assign)CGFloat contentHeight;

+ (instancetype)homeModelWithDict:(NSDictionary *)dict;

@end



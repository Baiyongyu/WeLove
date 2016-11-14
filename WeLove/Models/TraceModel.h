//
//  TraceModel.h
//  ant
//
//  Created by KevinCao on 16/8/18.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TraceModel : NSObject
//作物类型id
@property(nonatomic,copy)NSString *cropTypeId;
//作物名称
@property(nonatomic,copy)NSString *cropTypeName;
//田块名称
@property(nonatomic,copy)NSString *fieldName;
//田块数量
@property(nonatomic,copy)NSNumber *fieldCount;
//养殖方式
@property(nonatomic,copy)NSString *farmTypeName;
//生长周期
@property(nonatomic,copy)NSNumber *growDays;
//农药
@property(nonatomic,copy)NSString *pesticideDes;
//当前周期
@property(nonatomic,copy)NSString *currentPeriodName;
//农事活动数组
@property(nonatomic,copy)NSArray *activityList;
@end

@interface TraceActivityModel : NSObject
//活动图标
@property(nonatomic,strong)UIImage *activityImage;
//活动类别名称
@property(nonatomic,copy)NSString *activityTypeName;
//具体活动列表
@property(nonatomic,copy)NSArray *activityDetailList;
//内容高度
@property(nonatomic,assign)CGFloat contentHeight;
@end

@interface TraceDetailActivityModel : NSObject
//活动描述
@property(nonatomic,copy)NSString *activityDescription;
//活动时间
@property(nonatomic,copy)NSString *activityDate;
//活动图片数组
@property(nonatomic,copy)NSArray *activityPicUrls;
@end
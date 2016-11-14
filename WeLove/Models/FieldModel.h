//
//  FieldModel.h
//  ant
//
//  Created by KevinCao on 16/8/16.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  田块Model
 */
@interface FieldModel : NSObject
//田块id
@property(nonatomic,copy)NSString *fieldId;
//田块名称
@property(nonatomic,copy)NSString *fieldName;
//田块面积
@property(nonatomic,copy)NSNumber *fieldAcreage;
//田块图片
@property(nonatomic,copy)NSString *fieldImageUrl;
//田块作物列表
@property(nonatomic,copy)NSArray *fieldCropList;
//田块责任人
@property(nonatomic,copy)NSString *userName;
@end

/**
 *  田块分组Model
 */
@interface FieldGroupModel : NSObject
//分组id
@property(nonatomic,copy)NSString *groupId;
//分组名
@property(nonatomic,copy)NSString *groupName;
//田块列表
@property(nonatomic,copy)NSArray *fieldsList;
//选中的田块
@property(nonatomic,retain)NSMutableArray *selectedFields;
@end

/**
 *  作物Model
 */
@interface CropModel : NSObject
//作物类型id
@property(nonatomic,copy)NSString *cropTypeId;
//作物类型名称
@property(nonatomic,copy)NSString *cropTypeName;
//作物生长周期id
@property(nonatomic,copy)NSString *cropPeriodId;
//作物生长周期名称
@property(nonatomic,copy)NSString *cropPeriodName;
//作物图片
@property(nonatomic,strong)UIImage *cropImage;
//作物子类型数组
@property(nonatomic,copy)NSArray *subCropArray;
//作物id
@property(nonatomic,copy)NSString *cropId;
@end

/**
 *  作物子类型Model
 */
@interface CropSubCategoryModel : NSObject
//作物id
@property(nonatomic,copy)NSString *cropId;
//作物名称
@property(nonatomic,copy)NSString *cropName;
//田块数
@property(nonatomic,copy)NSNumber *fieldCount;
@end

/**
 *  农作物时间线Model
 */
@interface CropTimeLineModel : NSObject
//日期
@property(nonatomic,copy)NSDate *date;
//年份
@property(nonatomic,copy)NSString *year;
//农作物
@property(nonatomic,copy)NSArray *cropList;
@end

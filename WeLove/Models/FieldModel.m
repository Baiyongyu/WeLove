//
//  FieldModel.m
//  ant
//
//  Created by KevinCao on 16/8/16.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "FieldModel.h"

@implementation FieldModel

- (id)copyWithZone:(NSZone *)zone
{
    FieldModel *newItem = [[FieldModel allocWithZone:zone] init];
    newItem.fieldId = self.fieldId;
    newItem.fieldName = self.fieldName;
    newItem.fieldAcreage = self.fieldAcreage;
    newItem.fieldImageUrl = self.fieldImageUrl;
    newItem.fieldCropList = [self.fieldCropList copy];
    newItem.userName = self.userName;
    return newItem;
}

@end

@implementation FieldGroupModel

- (id)copyWithZone:(NSZone *)zone
{
    FieldGroupModel *newItem = [[FieldGroupModel allocWithZone:zone] init];
    newItem.groupId = self.groupId;
    newItem.groupName = self.groupName;
    newItem.fieldsList = [self.fieldsList copy];
    newItem.selectedFields = self.selectedFields;
    return newItem;
}

@end

@implementation CropModel

- (id)copyWithZone:(NSZone *)zone
{
    CropModel *newItem = [[CropModel allocWithZone:zone] init];
    newItem.cropTypeId = self.cropTypeId;
    newItem.cropTypeName = self.cropTypeName;
    newItem.cropPeriodId = self.cropPeriodId;
    newItem.cropPeriodName = self.cropPeriodName;
    newItem.subCropArray = [self.subCropArray copy];
    newItem.cropId = self.cropId;
    return newItem;
}

- (UIImage *)cropImage
{
    if ([self.cropTypeId isEqualToString:@"1"]) {    //水稻
        return [UIImage imageNamed:@"ic_rice"];
    }
    if ([self.cropTypeId isEqualToString:@"2"]) {    //龙虾
        return [UIImage imageNamed:@"ic_shrimp"];
    }
    if ([self.cropTypeId isEqualToString:@"3"]) {    //鱼
        return [UIImage imageNamed:@"ic_fish"];
    }
    if ([self.cropTypeId isEqualToString:@"4"]) {    //鳖
        return [UIImage imageNamed:@"ic_turtle"];
    }
    return nil;
}

@end

@implementation CropSubCategoryModel

- (id)copyWithZone:(NSZone *)zone
{
    CropSubCategoryModel *newItem = [[CropSubCategoryModel allocWithZone:zone] init];
    newItem.cropId = self.cropId;
    newItem.cropName = self.cropName;
    newItem.fieldCount = self.fieldCount;
    return newItem;
}

@end

@implementation CropTimeLineModel

- (id)copyWithZone:(NSZone *)zone
{
    CropTimeLineModel *newItem = [[CropTimeLineModel allocWithZone:zone] init];
    newItem.date = self.date;
    newItem.year = self.year;
    newItem.cropList = [self.cropList copy];
    return newItem;
}

@end

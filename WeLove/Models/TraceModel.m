//
//  TraceModel.m
//  ant
//
//  Created by KevinCao on 16/8/18.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "TraceModel.h"

@implementation TraceModel

- (id)copyWithZone:(NSZone *)zone
{
    TraceModel *newItem = [[TraceModel allocWithZone:zone] init];
    newItem.cropTypeId = self.cropTypeId;
    newItem.cropTypeName = self.cropTypeName;
    newItem.fieldName = self.fieldName;
    newItem.fieldCount = self.fieldCount;
    newItem.farmTypeName = self.farmTypeName;
    newItem.growDays = self.growDays;
    newItem.pesticideDes = self.pesticideDes;
    newItem.currentPeriodName = self.currentPeriodName;
    newItem.activityList = [self.activityList copy];
    return newItem;
}

@end

@implementation TraceActivityModel

- (id)copyWithZone:(NSZone *)zone
{
    TraceActivityModel *newItem = [[TraceActivityModel allocWithZone:zone] init];
    newItem.activityImage = self.activityImage;
    newItem.activityTypeName = self.activityTypeName;
    newItem.activityDetailList = [self.activityDetailList copy];
    newItem.contentHeight = self.contentHeight;
    return newItem;
}

@end

@implementation TraceDetailActivityModel

- (id)copyWithZone:(NSZone *)zone
{
    TraceDetailActivityModel *newItem = [[TraceDetailActivityModel allocWithZone:zone] init];
    newItem.activityDescription = self.activityDescription;
    newItem.activityDate = self.activityDate;
    newItem.activityPicUrls = [self.activityPicUrls copy];
    return newItem;
}

@end

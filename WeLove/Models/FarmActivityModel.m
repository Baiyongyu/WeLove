//
//  FarmActivityModel.m
//  ant
//
//  Created by KevinCao on 16/8/16.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "FarmActivityModel.h"

@implementation FarmActivityModel

+ (instancetype)homeModelWithDict:(NSDictionary *)dict {
    
    FarmActivityModel *farm = [[FarmActivityModel alloc] init];
    [farm mj_setKeyValues:dict];
    return farm;
}

- (id)copyWithZone:(NSZone *)zone
{
    FarmActivityModel *newItem = [[FarmActivityModel allocWithZone:zone] init];
    newItem.activityId = self.activityId;
    newItem.activityName = self.activityName;
    newItem.activityDetailInfo = self.activityDetailInfo;
    newItem.pictureArray = [self.pictureArray copy];
    newItem.activityDate = [self.activityDate copy];
    newItem.activityPerson = self.activityPerson;
    newItem.fields = [self.fields copy];
    newItem.activityInput = self.activityInput;
    newItem.contentHeight = self.contentHeight;
    return newItem;
}

@end


//
//  HappyTimeModel.m
//  WeLove
//
//  Created by 宇玄丶 on 16/11/18.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "HappyTimeModel.h"

@implementation HappyTimeModel

+ (instancetype)homeModelWithDict:(NSDictionary *)dict {
    
    HappyTimeModel *farm = [[HappyTimeModel alloc] init];
    [farm mj_setKeyValues:dict];
    return farm;
}

- (id)copyWithZone:(NSZone *)zone
{
    HappyTimeModel *newItem = [[HappyTimeModel allocWithZone:zone] init];
    newItem.time = self.time;
    newItem.titleName = self.titleName;
    newItem.detailInfo = self.detailInfo;
    newItem.pictureArray = [self.pictureArray copy];
    newItem.contentHeight = self.contentHeight;
    return newItem;
}

@end


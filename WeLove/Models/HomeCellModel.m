//
//  HomeCellModel.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/28.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "HomeCellModel.h"

@implementation HomeCellModel

+ (instancetype)homeModelWithDict:(NSDictionary *)dict {
    
    HomeCellModel *model = [[HomeCellModel alloc] init];
    [model mj_setKeyValues:dict];
    return model;
}

- (id)copyWithZone:(NSZone *)zone {
    HomeCellModel *newItem = [[HomeCellModel allocWithZone:zone] init];
    newItem.icon = [self.icon copy];
    newItem.time = self.time;
    newItem.name = self.name;
    newItem.title = self.title;
    newItem.img = [self.img copy];
    newItem.info = self.info;
    newItem.detail = self.detail;
    newItem.info = self.info;
    newItem.oursName = self.oursName;
    newItem.btnTitle = self.btnTitle;
    return newItem;
}

@end

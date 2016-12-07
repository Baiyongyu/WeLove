//
//  XRImage.m
//  LoveLove
//
//  Created by 宇玄丶 on 2016/11/26.
//  Copyright © 2016年 北京116科技有限公司. All rights reserved.
//

#import "HomeWaterImage.h"

@implementation HomeWaterImage

+ (instancetype)imageWithDict:(NSDictionary *)dict {
    
    HomeWaterImage *model = [[HomeWaterImage alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end

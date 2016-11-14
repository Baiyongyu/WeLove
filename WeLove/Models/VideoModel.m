//
//  VideoModel.m
//  ant
//
//  Created by KevinCao on 2016/9/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (id)copyWithZone:(NSZone *)zone
{
    VideoModel *newItem = [[VideoModel allocWithZone:zone] init];
    newItem.channelId = self.channelId;
    newItem.deviceId = self.deviceId;
    newItem.deviceName = self.deviceName;
    return newItem;
}

@end

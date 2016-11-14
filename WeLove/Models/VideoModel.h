//
//  VideoModel.h
//  ant
//
//  Created by KevinCao on 2016/9/22.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
//通道id
@property(nonatomic,copy)NSString *channelId;
//设备id
@property(nonatomic,copy)NSString *deviceId;
//设备名称
@property(nonatomic,copy)NSString *deviceName;
@end

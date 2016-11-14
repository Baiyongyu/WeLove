//
//  VideoCache.h
//  inongtian
//
//  Created by KevinCao on 2016/11/3.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface VideoCache : NSManagedObject
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSString * videoLocalPath;
@end

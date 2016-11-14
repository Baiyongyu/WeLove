//
//  CacheManager.h
//  anz
//
//  Created by KevinCao on 16/7/14.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

//缓存大小
@property (nonatomic) NSCache *cache;

//缓存大小
@property (nonatomic) CGFloat cacheFileSize;
/**
 *  清除缓存单例
 */
+ (CacheManager *)sharedCacheManager;
/**
 *  清除缓存
 */
- (void)clearCache;

-(void)savaVideoLocalPath:(NSString *)videoLocalPath forUrl:(NSString *)videoUrl;

- (NSString *)inquiryVideoCache:(NSString *)videoUrl;

- (void)removeVideoCache:(NSString *)videoUrl;

@end

//
//  CacheManager.m
//  anz
//
//  Created by KevinCao on 16/7/14.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager ()
@property(nonatomic,strong)NSLock *lock;
@end

@implementation CacheManager

+ (CacheManager *)sharedCacheManager {
    static CacheManager *sharedManager = nil;
    static dispatch_once_t cacheManager;
    dispatch_once(&cacheManager, ^{
        if (!sharedManager) {
            sharedManager = [[CacheManager alloc] init];
            sharedManager.cache = [[NSCache alloc] init];
        }
    });
    return sharedManager;
    
}

- (CGFloat)cacheFileSize
{
    //缓存文件夹路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    //cache文件夹下所有文件
    NSArray *files = [fm subpathsAtPath:filePath];
    CGFloat folderSize = 0;
    //计算缓存文件大小
    for (NSString *path in files) {
        NSString *fileAbsolutePath = [filePath stringByAppendingPathComponent:path];
        folderSize += [[fm attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }
    CGFloat cacheFileSize = folderSize / (1024 * 1024);
    return cacheFileSize;
}

#pragma mark - 清除缓存
- (void)clearCache
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm subpathsAtPath:filePath];
    for (NSString *path in files) {
        NSError *error;
        NSString *fileAbsolutePath = [filePath stringByAppendingPathComponent:path];
        if ([fm fileExistsAtPath:fileAbsolutePath]) {
            [fm removeItemAtPath:fileAbsolutePath error:&error];
        }
    }
    [MBProgressHUD showTip:@"清除成功"];
}

@end

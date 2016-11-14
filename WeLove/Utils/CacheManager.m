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

-(void)savaVideoLocalPath:(NSString *)videoLocalPath forUrl:(NSString *)videoUrl
{
    [self removeVideoCache:videoUrl];
    NSManagedObjectContext *workContext = [NSManagedObjectContext generatePrivateContextWithParent:rootContext];
    VideoCache *item = [NSEntityDescription insertNewObjectForEntityForName:@"VideoCache" inManagedObjectContext:workContext];
    item.videoLocalPath = videoLocalPath;
    item.videoUrl = videoUrl;
    NSError *error;
    if(![workContext save:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    else
    {
        [kAppDelegate saveContextWithWait:YES];
    }
}

- (void)removeVideoCache:(NSString *)videoUrl
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *workContext = [NSManagedObjectContext generatePrivateContextWithParent:rootContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VideoCache" inManagedObjectContext:workContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"videoUrl = %@",videoUrl];
    [fetchRequest setPredicate:Predicate];
    NSArray *fetchedObjects = [workContext executeFetchRequest:fetchRequest error:&error];
    if (!fetchedObjects.count) {
        return;
    }
    for (NSManagedObject* item in fetchedObjects)
    {
        [workContext deleteObject:item];
    }
    if(![workContext save:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    else
    {
        [kAppDelegate saveContextWithWait:YES];
    }
}

//查询图片缓存
- (NSString *)inquiryVideoCache:(NSString *)videoUrl
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *workContext = [NSManagedObjectContext generatePrivateContextWithParent:rootContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VideoCache" inManagedObjectContext:workContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSPredicate *Predicate = [NSPredicate predicateWithFormat:@"videoUrl = %@",videoUrl];
    [fetchRequest setPredicate:Predicate];
    NSArray *fetchedObjects = [workContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count) {
        VideoCache *item = [fetchedObjects firstObject];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths[0] stringByAppendingPathComponent:item.videoLocalPath];
        return path;
    } else {
        return nil;
    }
}

@end

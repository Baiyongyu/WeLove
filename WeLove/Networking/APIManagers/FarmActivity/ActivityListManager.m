//
//  ActivityListManager.m
//  inongtian
//
//  Created by KevinCao on 2016/11/3.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "ActivityListManager.h"

@interface ActivityListManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation ActivityListManager
@synthesize errorMessage;

#pragma mark - APIManagerValidator
- (BOOL)manager:(BaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([data[@"code"] integerValue]==20000) {
        return YES;
    }
    NSString *message = data[@"message"];
    if (message.length) {
        errorMessage = message;
    }
    return NO;
}

#pragma mark - APIManager
- (void)reformData:(NSDictionary *)data
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *activityDic in [QMUtil checkArray:data[@"data"]]) {
        HappyTimeModel *activityData = [[HappyTimeModel alloc] init];
        activityData.activityId = [QMUtil checkString:activityDic[@"activity_id"]];
        activityData.activityDate = [QMUtil getDateFromeString:[QMUtil checkString:activityDic[@"created_at"]]];
        activityData.activityName = [QMUtil checkString:activityDic[@"activity_type_name"]];
        activityData.activityDetailInfo = [QMUtil checkString:activityDic[@"activity_intro"]];
        NSMutableArray *mediaArray = [NSMutableArray array];
        NSString *imageUrls = [QMUtil checkString:activityDic[@"activity_urls"]];
        if (imageUrls.length) {
            for (NSString *imageUrl in [imageUrls componentsSeparatedByString:@","]) {
                QMImageModel *imageInfo = [[QMImageModel alloc] init];
                imageInfo.imageUrl = imageUrl;
                [mediaArray addObject:imageInfo];
            }
        }
        NSString *videoUrls = [QMUtil checkString:activityDic[@"activity_videos"]];
        NSString *videoImageUrls = [QMUtil checkString:activityDic[@"activity_videos_urls"]];
        if (videoUrls.length && videoImageUrls.length) {
            NSArray *videoUrlArray = [videoUrls componentsSeparatedByString:@","];
            NSArray *videoImageUrlArray = [videoImageUrls componentsSeparatedByString:@","];
            for (int i=0; i<MIN(videoUrlArray.count, videoImageUrlArray.count); i++) {
                QMImageModel *videoInfo = [[QMImageModel alloc] init];
                videoInfo.isVideo = YES;
                videoInfo.videoUrl = videoUrlArray[i];
                videoInfo.imageUrl = videoImageUrlArray[i];
                [mediaArray addObject:videoInfo];
            }
        }
        activityData.pictureArray = mediaArray;
        CGFloat height = 85;
        CGSize activityNameSize = [QMUtil sizeWithString:activityData.activityName font:XiHeiFont(16) size:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX)];
        if(activityNameSize.height>20)
        {
            height += (activityNameSize.height-20);
        }
        CGSize activityDetailSize = [QMUtil sizeWithString:activityData.activityDetailInfo font:XiHeiFont(16) size:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX)];
        height += activityDetailSize.height;
        if (activityData.pictureArray.count) {
            CGFloat itemHeight = (kScreenWidth-100-20)/3;
            if (activityData.pictureArray.count%3==0) {
                height += (activityData.pictureArray.count/3-1)*10 + (activityData.pictureArray.count/3)*itemHeight;
            } else {
                height += activityData.pictureArray.count/3*10 + (activityData.pictureArray.count/3+1)*itemHeight;
            }
            height += 15;
        }
        activityData.contentHeight = height;
        [tmpArray addObject:activityData];
    }
    self.activityList = tmpArray;
}

- (NSString *)methodName
{
    return Farm_Activity_List_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

@end






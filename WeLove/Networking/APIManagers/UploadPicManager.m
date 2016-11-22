//
//  UploadPicManager.m
//  ant
//
//  Created by KevinCao on 16/8/19.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "UploadPicManager.h"

@interface UploadPicManager ()
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation UploadPicManager
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
    NSDictionary *dataDic = data[@"data"];
    if ([dataDic isKindOfClass:[NSDictionary class]]) {
        self.picUrl = [QMUtil checkString:dataDic[@"detail_pic_url"]];
    }
}

- (NSString *)methodName
{
    return Upload_Pic_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeUpload;
}

@end

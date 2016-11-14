//
//  BaseAPIManager.h
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseAPIManager;
/*---------------------API回调-----------------------*/
@protocol APIManagerApiCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager;
- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager;
@end

/*---------------------API参数-----------------------*/
@protocol APIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(BaseAPIManager *)manager;
@optional
- (void (^)(id <AFMultipartFormData> formData))uploadBlock:(BaseAPIManager *)manager;
@end

/*---------------------API验证器-----------------------*/
@protocol APIManagerValidator <NSObject>
@required
- (BOOL)manager:(BaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
@end

typedef NS_ENUM (NSUInteger, APIManagerErrorType){
    APIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    APIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    APIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    APIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    APIManagerErrorTypeTimeout,       //请求超时。ApiProxy设置的是20秒超时，具体超时时间的设置请自己去看ApiProxy的相关代码。
    APIManagerErrorTypeNoNetWork,     //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    APIManagerErrorLoginTimeout       //登录超时
};

typedef NS_ENUM (NSUInteger, APIManagerRequestType){
    APIManagerRequestTypeGet,
    APIManagerRequestTypePost,
    APIManagerRequestTypeUpload,
    APIManagerRequestTypeDelete,
    APIManagerRequestTypePut
};

/*---------------------APIManager-----------------------*/

@protocol APIManager <NSObject>
@optional
- (void)reformData:(id)data;
- (AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer;
- (AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer;
@required
- (NSString *)methodName;
- (APIManagerRequestType)requestType;

@end

@interface BaseAPIManager : NSObject
@property (nonatomic, weak) id<APIManagerApiCallBackDelegate> delegate;
@property (nonatomic, weak) id<APIManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<APIManagerValidator> validator;
@property (nonatomic, weak) NSObject<APIManager> *child;
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, strong) id responseData;
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, assign, readonly) APIManagerErrorType errorType;
@property (nonatomic, assign, readonly)int totalPageNumber;
- (NSInteger)loadDataWithHUDOnView:(UIView *)view;
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;
@end

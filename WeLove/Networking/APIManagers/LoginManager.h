//
//  LoginAPIManager.h
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : BaseAPIManager <APIManager>

+ (void)autoReloginSuccess:(void(^)())success failure:(void(^)())failure;

@end

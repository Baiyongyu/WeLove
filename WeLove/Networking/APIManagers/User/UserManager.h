//
//  UserManager.h
//  anz
//
//  Created by KevinCao on 16/7/5.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseAPIManager.h"

@interface UserManager : BaseAPIManager <APIManager>

@property(nonatomic,copy,readonly)NSString *session;

@property(nonatomic,retain)UserModel *userInfo;

+ (instancetype)sharedInstance;

- (void)saveUserInfo;

- (void)clearUserInfo;

- (void)updatePassword:(NSString *)password;

@end

//
//  UserModel.h
//  anz
//
//  Created by KevinCao on 16/6/29.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户Model
 */
@interface UserModel : NSObject
//是否登录
@property(nonatomic,assign)BOOL isLogin;
//用户id
@property(nonatomic,copy)NSString *userId;
//头像链接
@property(nonatomic,copy)NSString *avatarImageUrl;
//用户名
@property(nonatomic,copy)NSString *userName;
//密码
@property(nonatomic,copy)NSString *password;
//手机号码
@property(nonatomic,copy)NSString *phoneNumber;
@end

/**
 *  农场信息Model
 */
@interface FarmModel : NSObject
//农场名称
@property(nonatomic,copy)NSString *farmName;
//农场主
@property(nonatomic,copy)NSString *farmOwnerName;
//农场地址
@property(nonatomic,copy)NSString *farmAddress;
//联系方式
@property(nonatomic,copy)NSString *phoneNumber;
//农场介绍
@property(nonatomic,copy)NSString *farmIntroduction;
//图片数组
@property(nonatomic,copy)NSArray *photos;
@end

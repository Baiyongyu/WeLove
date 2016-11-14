//
//  UserModel.m
//  anz
//
//  Created by KevinCao on 16/6/29.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)copyWithZone:(NSZone *)zone
{
    UserModel *newItem = [[UserModel allocWithZone:zone] init];
    newItem.isLogin = self.isLogin;
    newItem.userId = self.userId;
    newItem.avatarImageUrl = self.avatarImageUrl;
    newItem.userName = self.userName;
    newItem.password = self.password;
    newItem.phoneNumber = self.phoneNumber;
    return newItem;
}

@end

@implementation FarmModel

- (id)copyWithZone:(NSZone *)zone
{
    FarmModel *newItem = [[FarmModel allocWithZone:zone] init];
    newItem.farmName = self.farmName;
    newItem.farmOwnerName = self.farmOwnerName;
    newItem.farmAddress = self.farmAddress;
    newItem.phoneNumber = self.phoneNumber;
    newItem.farmIntroduction = self.farmIntroduction;
    newItem.photos = [self.photos copy];
    return newItem;
}

@end

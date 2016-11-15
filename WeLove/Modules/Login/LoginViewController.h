//
//  LoginViewController.h
//  LoveMySmallV
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
+(void)presentLoginPageSuccess:(void(^)())success;
@property(nonatomic,copy)void(^loginSuccessBlock)();
@end

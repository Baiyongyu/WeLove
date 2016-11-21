//
//  ANZLoginViewController.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "BaseViewController.h"

@interface ANTLoginViewController : BaseViewController
+(void)presentLoginPageSuccess:(void(^)())success;
@property(nonatomic,copy)void(^loginSuccessBlock)();
@end

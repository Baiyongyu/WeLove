//
//  ANZLoginViewController.h
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANTBaseViewController.h"

@interface ANTLoginViewController : ANTBaseViewController
+(void)presentLoginPageSuccess:(void(^)())success;
@property(nonatomic,copy)void(^loginSuccessBlock)();
@end

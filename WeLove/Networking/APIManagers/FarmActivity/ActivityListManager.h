//
//  ActivityListManager.h
//  inongtian
//
//  Created by KevinCao on 2016/11/3.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "BaseAPIManager.h"

@interface ActivityListManager : BaseAPIManager <APIManager>
@property(nonatomic,copy)NSArray *activityList;
@end

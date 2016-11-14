//
//  UploadPicManager.h
//  ant
//
//  Created by KevinCao on 16/8/19.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseAPIManager.h"

@interface UploadPicManager : BaseAPIManager <APIManager>
@property(nonatomic,copy)NSString *picUrl;
@end

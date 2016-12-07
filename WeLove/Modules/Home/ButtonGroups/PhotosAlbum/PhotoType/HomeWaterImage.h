//
//  XRImage.h
//  LoveLove
//
//  Created by 宇玄丶 on 2016/11/26.
//  Copyright © 2016年 北京116科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HomeWaterImage : NSObject

@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;

+ (instancetype)imageWithDict:(NSDictionary *)dict;
@end

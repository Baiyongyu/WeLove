//
//  HomeCellModel.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/28.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCellModel : NSObject
/** 图片 */
@property(nonatomic, copy) NSString *icon;
/** 名字 */
@property(nonatomic, copy) NSString *name;
/** 时间 */
@property(nonatomic, copy) NSString *time;
/** 幸福*/
@property(nonatomic, copy) NSString *title;
/** 图片 */
@property(nonatomic, copy) NSString *img;
/** info */
@property(nonatomic, copy) NSString *info;
/** 详细 */
@property(nonatomic, copy) NSString *detail;
/** 我们的名字 */
@property(nonatomic, copy) NSString *oursName;
/** 按钮 */
@property(nonatomic, copy) NSString *btnTitle;

+ (instancetype)homeModelWithDict:(NSDictionary *)dict;

@end

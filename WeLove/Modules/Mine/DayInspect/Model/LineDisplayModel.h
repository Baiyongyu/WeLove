//
//  LineDisplayModel.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineDisplayModel : NSObject
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,copy) NSString *day;
@property (nonatomic,strong) NSMutableArray *imgArray;
@end

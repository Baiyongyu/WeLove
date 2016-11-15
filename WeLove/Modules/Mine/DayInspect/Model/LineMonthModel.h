//
//  LineMonthModel.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineMonthModel : NSObject

@property (nonatomic,copy) NSString *month;
@property (nonatomic,strong) NSMutableArray *days;
@property (nonatomic,assign) NSInteger monthRows;
@property (nonatomic,assign) BOOL shouldOpen;
@property (nonatomic,strong) NSMutableArray *displayArray;

- (instancetype)initWithMonth:(NSString *)month days:(NSArray *)days;

@end

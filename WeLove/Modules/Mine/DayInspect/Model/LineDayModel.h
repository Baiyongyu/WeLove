//
//  LineDayModel.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineDayModel : NSObject
@property (nonatomic,copy) NSString *day;
@property (nonatomic,strong) NSArray *imgArray;

@property (nonatomic,assign) NSInteger dayRows;
@property (nonatomic,strong) NSMutableArray *displayArray;

- (instancetype)initWithDay:(NSString *)day imgArray:(NSArray *)imgArray;

@end

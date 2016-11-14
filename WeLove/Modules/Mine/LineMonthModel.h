//
//  LineMonthModel.h
//  60730-TimeLine
//
//  Created by iOS_Chris on 16/8/1.
//  Copyright © 2016年 shu. All rights reserved.
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

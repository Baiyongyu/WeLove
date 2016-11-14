//
//  LineDayModel.h
//  60730-TimeLine
//
//  Created by iOS_Chris on 16/8/1.
//  Copyright © 2016年 shu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineDayModel : NSObject
@property (nonatomic,copy) NSString *day;
@property (nonatomic,strong) NSArray *imgArray;

@property (nonatomic,assign) NSInteger dayRows;
@property (nonatomic,strong) NSMutableArray *displayArray;

- (instancetype)initWithDay:(NSString *)day imgArray:(NSArray *)imgArray;

@end

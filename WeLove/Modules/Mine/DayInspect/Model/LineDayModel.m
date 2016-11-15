//
//  LineDayModel.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "LineDayModel.h"
#import "LineDisplayModel.h"

@implementation LineDayModel

- (instancetype)initWithDay:(NSString *)day imgArray:(NSArray *)imgArray {
    self = [super init];
 
    self.day = day;
    self.imgArray = imgArray;

    self.dayRows = 0;
    
    if (self.imgArray.count % 3 != 0) {
        self.dayRows = self.imgArray.count / 3 + 1;
    }else {
        self.dayRows = self.imgArray.count / 3 ;
    }
    
    
    for (int m = 0; m < self.dayRows; m++) {
        LineDisplayModel *pModel = [[LineDisplayModel alloc] init];
        pModel.imgArray = [[NSMutableArray alloc]init];
        
        if (m == 0) {
            pModel.isFirst = YES;
            pModel.day = self.day;
        }else {
            pModel.isFirst = NO;
            pModel.day = @"";
        }
        for (int n = 0; n < 3; n++) {
        
            if (self.imgArray.count > m * 3 + n) {
                [pModel.imgArray addObject:self.imgArray[m * 3 + n]];
            }
            
        }
        [self.displayArray addObject:pModel];
    }
    return self;
}

- (NSMutableArray *)displayArray {
    if (!_displayArray) {
        _displayArray = [[NSMutableArray alloc] init];
    }
    return _displayArray;
}

@end

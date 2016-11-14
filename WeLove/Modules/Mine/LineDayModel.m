//
//  LineDayModel.m
//  60730-TimeLine
//
//  Created by iOS_Chris on 16/8/1.
//  Copyright © 2016年 shu. All rights reserved.
//

#import "LineDayModel.h"
#import "LineDisplayModel.h"

@implementation LineDayModel
- (instancetype)initWithDay:(NSString *)day imgArray:(NSArray *)imgArray
{
    self = [super init];
 
    self.day = day;
    self.imgArray = imgArray;

    self.dayRows = 0;
    
    if (self.imgArray.count % 3 != 0) {
        self.dayRows = self.imgArray.count / 3 + 1;
    }else{
        self.dayRows = self.imgArray.count / 3 ;
    }
    
//    NSLog(@"dayRows : %d",self.dayRows);
    
    
    for (int m = 0; m < self.dayRows; m++) {
        LineDisplayModel *pModel = [[LineDisplayModel alloc]init];
        pModel.imgArray = [[NSMutableArray alloc]init];
        
        if (m == 0) {
            pModel.isFirst = YES;
            pModel.day = self.day;
        }else{
            pModel.isFirst = NO;
            pModel.day = @"";
        }
        
        
        for (int n = 0; n < 3; n++) {
            
          
            if (self.imgArray.count > m * 3 + n) {
//                  NSLog(@"m : %d , n : %d , index : %d",m,n,m * 3 + n);
                [pModel.imgArray addObject:self.imgArray[m * 3 + n]];
            }
            
        }
        
//        NSLog(@"pModel : %d , %@ , %@",pModel.isFirst,pModel.day,pModel.imgArray);
        
        [self.displayArray addObject:pModel];
    }
    
//    NSLog(@"该天行数 ： %d",self.dayRows);
 
    return self;
}

-(NSMutableArray *)displayArray
{
    if (!_displayArray) {
        _displayArray = [[NSMutableArray alloc]init];
    }
    return _displayArray;
}

@end

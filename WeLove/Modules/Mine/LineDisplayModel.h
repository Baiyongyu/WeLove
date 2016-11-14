//
//  LineDisplayModel.h
//  60730-TimeLine
//
//  Created by iOS_Chris on 16/8/1.
//  Copyright © 2016年 shu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineDisplayModel : NSObject
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,copy) NSString *day;
@property (nonatomic,strong) NSMutableArray *imgArray;
@end

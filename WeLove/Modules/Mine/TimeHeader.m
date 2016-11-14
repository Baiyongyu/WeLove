//
//  TimeHeader.m
//  60730-TimeLine
//
//  Created by iOS_Chris on 16/7/30.
//  Copyright © 2016年 shu. All rights reserved.
//

#import "TimeHeader.h"

@implementation TimeHeader

-(instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle] loadNibNamed:@"TimeHeader" owner:nil options:nil][0];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}



@end

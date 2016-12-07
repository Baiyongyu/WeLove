//
//  FlyTextView.m
//  BulletScreen
//
//  Created by 宇玄丶 on 2016/12/5.
//  Copyright © 2016年 宇玄丶. All rights reserved.
//

#import "FlyTextView.h"

@implementation FlyTextView {
    CGFloat Y;
    CGFloat Height;
    CGRect  SuperRect;
}

- (instancetype)initWithY:(CGFloat)y AndText:(NSString*)text AndWordSize:(CGFloat)wordSize {
    SuperRect = [[UIScreen mainScreen] bounds];
    CGFloat width = text.length * wordSize * 2;
    Y = y;
    Height = wordSize * 1.2;
    self = [super initWithFrame:CGRectMake(SuperRect.size.width, y, width, Height)];
    if(self){
        self.text = text;
        self.font = [UIFont systemFontOfSize:wordSize];
        [self starFly];
    }
    return self;
}

- (void)starFly {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:6 animations:^{
        self.frame = CGRectMake(SuperRect.origin.x - self.frame.size.width, Y, self.frame.size.width, Height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

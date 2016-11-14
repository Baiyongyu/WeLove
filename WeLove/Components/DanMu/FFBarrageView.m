//
//  FFBarrageView.m
//  FFBarrageDemo
//
//  Created by Fan on 16/10/31.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import "FFBarrageView.h"

#define Padding 10.0f
#define HeadHeight  40.0f

#define kAnimationDuration  5.0

@interface FFBarrageView ()
@property(nonatomic, strong) UILabel *lblComment;

@property(nonatomic, strong) UIImageView *headImage;

/**
 动画时间
 */
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation FFBarrageView

- (instancetype)initWithComment:(NSString *)comment
{
    if(self = [super init]) {
        self.backgroundColor = [UIColor orangeColor];
        self.layer.cornerRadius = 15.0f;
        self.duration = kAnimationDuration;
        
        CGFloat width = [comment sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}].width;
        self.bounds = CGRectMake(0, 0, width+2*Padding + HeadHeight, 30);
        self.lblComment.text = comment;
        self.lblComment.frame = CGRectMake(Padding+HeadHeight, 0, width, 30);
        
        self.headImage.frame = CGRectMake(-Padding, -Padding, HeadHeight, HeadHeight);
        self.headImage.layer.cornerRadius = (HeadHeight) /2.0;
        self.headImage.layer.borderWidth = 1;
        self.headImage.layer.borderColor = [UIColor grayColor].CGColor;
        self.headImage.image = [UIImage imageNamed:@"head.jpg"];
    }
    return self;
}

- (void)startAnimation
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat totoalWidth = screenWidth + self.bounds.size.width;
    
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    //速度
    CGFloat speed = totoalWidth / self.duration;
    CGFloat enterDuration = (CGRectGetWidth(self.bounds) + 2 *Padding) / speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:self.duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         frame.origin.x -= totoalWidth;
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (self.moveStatusBlock) {
                             self.moveStatusBlock(End);
                         }
                     }];
}

- (void)stopAnimation
{
    [self.layer removeAllAnimations];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)enterScreen
{
    //弹幕进入
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }

}

#pragma mark - setter
- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
}

#pragma mark - getter
- (UILabel *)lblComment
{
    if (!_lblComment) {
        _lblComment = [[UILabel alloc] init];
        _lblComment.font = [UIFont systemFontOfSize:14.0f];
        _lblComment.textAlignment = NSTextAlignmentCenter;
        _lblComment.textColor = [UIColor whiteColor];
        [self addSubview:_lblComment];
    }
    return _lblComment;
}

- (UIImageView *)headImage
{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.clipsToBounds = YES;
//        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_headImage];
    }
    return _headImage;
}
@end

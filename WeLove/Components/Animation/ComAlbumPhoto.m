//
//  ComAlbumPhoto.m
//  LoveMySmallV
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "ComAlbumPhoto.h"

@implementation ComAlbumPhoto

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.drawView = [[ComDrawView alloc]initWithFrame:self.bounds];
        // 修复图片让其按自身属性符合
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.drawView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.drawView];
        [self addSubview:self.imageView];
#pragma mark - 这里面有个TIME的高级使用:就是forMode后面的属性,默认就是当点击窗口事件产生后，time定时器的那个线程将会取消变的无效
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(movePhotos) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:@"NSDefaultRunLoopMode"];
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [self addGestureRecognizer:tap];
        
#pragma mark - 这里实现一个swip手势,注册.该注册是定义向左还是向右滑动的动作,并处理事件用于左右滑动
        // UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipImage)];
        //  [swip setDirection:UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight];
        // [self addGestureRecognizer:swip];
    }
    return self;
}

- (void)tapImage {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.state == ComPhotoStateNormal) {
            self.oldFrame = self.frame;
            self.oldAlpha = self.alpha;
            self.oldSpeed = self.speed;
            self.frame = CGRectMake(20, 20, self.superview.bounds.size.width - 40, self.superview.bounds.size.height - 40);
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            [self.superview bringSubviewToFront:self];
            self.speed = 0;
            self.alpha = 1;
            self.state = ComPhotoStateBig;
            
        } else if (self.state == ComPhotoStateBig) {
            self.frame = self.oldFrame;
            self.alpha = self.oldAlpha;
            self.speed = self.oldSpeed;
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            self.state = ComPhotoStateNormal;
        }
    }];
}

- (void)swipImage {
    
    if (self.state == ComPhotoStateBig) {
        [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.state = ComPhotoStateDraw;
    } else if (self.state == ComPhotoStateDraw) {
        [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.state = ComPhotoStateBig;
    }
}

#pragma mark - 这里将已经分配好的图片加载到对应的UIViewContorl当中
- (void)updateImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setImageAlphaAndSpeedAndSize:(float)alpha {
    self.alpha = alpha;
    self.speed = alpha;
    self.transform = CGAffineTransformScale(self.transform, alpha, alpha);
}

#pragma mark - 由定时器控制图片流的流动，当图片超出屏幕时返回来，y值随机 来改变下次移动的位置 重新播放
- (void)movePhotos {
    self.center = CGPointMake(self.center.x + self.speed, self.center.y);
    if (self.center.x > self.superview.bounds.size.width + self.frame.size.width/2) {
        self.center = CGPointMake(-self.frame.size.width/2, arc4random()%(int)(self.superview.bounds.size.height - self.bounds.size.height) + self.bounds.size.height/2);
    }
}

@end

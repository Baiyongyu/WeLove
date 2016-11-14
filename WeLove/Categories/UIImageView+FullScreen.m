//
//  UIImageView+FullScreen.m
//  ant
//
//  Created by KevinCao on 16/8/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "UIImageView+FullScreen.h"
#import <objc/runtime.h>

@interface UIImageView ()
@property(nonatomic,strong)ImageScrollView *imageScrollView;
@end

@implementation UIImageView (FullScreen)

-(NSNumber *)enableFullScreen
{
    return objc_getAssociatedObject(self,@selector(enableFullScreen));
}

-(void)setEnableFullScreen:(NSNumber *)value
{
    if (value.boolValue) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
    }
    objc_setAssociatedObject(self,@selector(enableFullScreen),(id)value,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(ImageScrollView *)imageScrollView
{
    return objc_getAssociatedObject(self,@selector(imageScrollView));
}

-(void)setImageScrollView:(ImageScrollView *)value
{
    objc_setAssociatedObject(self,@selector(imageScrollView),(id)value,OBJC_ASSOCIATION_RETAIN);
}

- (void)tapAction
{
    if (!self.imageScrollView) {
        self.imageScrollView = [[ImageScrollView alloc] init];
    }
    self.imageScrollView.image = self.image;
    [self.imageScrollView showFromRect:[self convertRect:self.bounds toView:nil]];
}

@end

@interface ImageScrollView () <UIScrollViewDelegate>
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIScrollView *contentView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,assign)CGRect rect;
@end
@implementation ImageScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showFromRect:(CGRect)rect
{
    self.rect = rect;
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    if (!self.bgView.superview) {
        [kRootWindow addSubview:self.bgView];
        if (!self.contentView.superview) {
            [self.bgView addSubview:self.contentView];
            if (!self.imageView.superview) {
                [self.contentView addSubview:self.imageView];
            }
        }
    }
    self.imageView.frame = rect;
    CGFloat width = MIN(self.bgView.width, self.image.size.width/[UIScreen mainScreen].scale);
    CGFloat height = MIN(self.bgView.height, self.image.size.height/[UIScreen mainScreen].scale);
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = CGRectMake((self.bgView.width-width)/2.0, (self.bgView.height-height)/2.0, width, height);
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointZero;
        self.contentView.zoomScale = 1.0;
        self.imageView.frame = self.rect;
        self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right;
    CGFloat Hs = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom;
    CGFloat W = self.imageView.frame.size.width;
    CGFloat H = self.imageView.frame.size.height;
    CGRect rct = self.imageView.frame;
    rct.origin.x = MAX((Ws-W)*0.5, 0);
    rct.origin.y = MAX((Hs-H)*0.5, 0);
    self.imageView.frame = rct;
}

#pragma mark - actions
//单击 / 双击 手势
- (void)TapsAction:(UITapGestureRecognizer *)tap
{
    NSInteger tapCount = tap.numberOfTapsRequired;
    if (2 == tapCount)
    {
        //双击
        if (self.contentView.minimumZoomScale <= self.contentView.zoomScale && self.contentView.maximumZoomScale > self.contentView.zoomScale)
        {
            [self.contentView setZoomScale:self.contentView.maximumZoomScale animated:YES];
        }
        else
        {
            [self.contentView setZoomScale:self.contentView.minimumZoomScale animated:YES];
        }
        return;
    }
    [self dismiss];
}

#pragma mark - getters and setters
-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _bgView;
}

-(UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.bgView.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.delegate = self;
        _contentView.maximumZoomScale = 2.0;
        //双击
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(TapsAction:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [_contentView addGestureRecognizer:doubleTapGesture];
        
        //单击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(TapsAction:)];
        [tapGesture setNumberOfTapsRequired:1];
        [_contentView addGestureRecognizer:tapGesture];
        
        //双击失败之后执行单击
        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return _contentView;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end

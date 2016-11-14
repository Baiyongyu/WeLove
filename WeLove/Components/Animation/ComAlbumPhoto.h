//
//  ComAlbumPhoto.h
//  LoveMySmallV
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComDrawView.h"

typedef NS_ENUM(NSInteger, ComPhotoState) {
    ComPhotoStateNormal,
    ComPhotoStateBig,
    ComPhotoStateDraw,
    ComPhotoStateTogether,
    ComPhotoStateTogetherBig
};

@interface ComAlbumPhoto : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ComDrawView *drawView;
@property (nonatomic) float speed;
@property (nonatomic) CGRect oldFrame;
@property (nonatomic) float oldSpeed;
@property (nonatomic) float oldAlpha;
@property (nonatomic) int state;

- (void)updateImage:(UIImage *)image;
- (void)setImageAlphaAndSpeedAndSize:(float)alpha;

@end

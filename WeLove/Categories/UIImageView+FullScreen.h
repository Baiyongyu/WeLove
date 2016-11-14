//
//  UIImageView+FullScreen.h
//  ant
//
//  Created by KevinCao on 16/8/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FullScreen)
@property(nonatomic,copy)NSNumber *enableFullScreen;
@end

@interface ImageScrollView : UIView
@property(nonatomic,strong)UIImage *image;
- (void)showFromRect:(CGRect)rect;
@end

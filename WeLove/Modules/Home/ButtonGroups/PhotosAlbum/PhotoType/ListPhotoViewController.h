//
//  ListPhotoViewController.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListPhotoViewController : UIViewController
@end

@interface MyCell : UITableViewCell
/** 图片imgView */
@property (nonatomic, strong) UIImageView *pictureView;
/** 标题label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容Label */
@property (nonatomic, strong) UILabel *littleLabel;
/** 遮挡的View */
@property (nonatomic, strong) UIView *coverview;
/** cell的位移 */
- (CGFloat)cellOffset;
/** 设置图片 */
- (void)setImg:(UIImage *)img;
@end

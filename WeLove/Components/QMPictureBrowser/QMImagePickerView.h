//
//  QMImagePickerView.h
//  inongtian
//
//  Created by KevinCao on 2016/10/28.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImagePickerBlock)(NSArray *);

@interface QMImagePickerView : UIView
@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic,copy)ImagePickerBlock imagePickerBlock;
-(instancetype)initWithMaxImageCount:(NSInteger)maxImageCount;
@end

@interface QMImagePickerCell : UICollectionViewCell
@property(nonatomic, strong) UIButton *imageViewBtn;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *cancleBtn;
@property(nonatomic, strong) UIImage *image;
//视频图标
@property(nonatomic,strong)UIImageView *videoIcon;
@end

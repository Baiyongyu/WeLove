//
//  QMPictureBrowser.h
//  inongtian
//
//  Created by KevinCao on 2016/10/25.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMPictureProgressView.h"

@interface QMPictureBrowser : UIView
@property(nonatomic,retain)NSArray *pictureArray;
//每行显示图片数量
@property(nonatomic,assign)int columeCount;
//唯一标识
@property(nonatomic,assign)NSInteger indexFlag;
@end

@interface QMPictureCell : UICollectionViewCell
//图片
@property(nonatomic,strong)UIImageView *picture;
@property(nonatomic,copy)QMImageModel *imageData;
//进度
@property(nonatomic,strong)QMPictureProgressView *progressView;
@property(nonatomic,assign)CGFloat progress;
//唯一标识
@property(nonatomic,assign)NSInteger indexFlag;
@property(nonatomic,retain)NSIndexPath *indexPath;

@end

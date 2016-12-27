//
//  QMNavigateCollectionViewCell.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/7.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMNavigateCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setImageForCellWithIndexpath:(NSIndexPath*)indexpath;

@end

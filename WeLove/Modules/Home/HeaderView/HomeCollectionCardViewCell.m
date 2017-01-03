//
//  HomeCollectionCardViewCell.m
//  LoveLove
//
//  Created by 宇玄丶 on 2016/11/27.
//  Copyright © 2016年 北京116科技有限公司. All rights reserved.
//

#import "HomeCollectionCardViewCell.h"

@implementation HomeCollectionCardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.cornerRadius = 1.0f;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)setImageName:(NSString *)imageName {
  _imageName = [imageName copy];
    self.imageView.image = [UIImage imageNamed:_imageName];
}

@end

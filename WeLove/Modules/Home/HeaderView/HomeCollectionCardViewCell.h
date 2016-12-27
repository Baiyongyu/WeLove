//
//  HomeCollectionCardViewCell.h
//  LoveLove
//
//  Created by 宇玄丶 on 2016/11/27.
//  Copyright © 2016年 北京116科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionCardViewCell : UICollectionViewCell

@property(nonatomic,strong)NSString *imageName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

//
//  QMNavigateCollectionViewCell.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/7.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "QMNavigateCollectionViewCell.h"

@interface QMNavigateCollectionViewCell()
@end

@implementation QMNavigateCollectionViewCell

- (void)setImageForCellWithIndexpath:(NSIndexPath*)indexpath{
    NSArray *imageNameArray = [NSArray arrayWithObjects:
                               @"tool_button_home_nongzi_se",
                               @"tool_button_home_nongji_sel",
                               @"tool_button_home_nongshi_sel",
                               @"tool_button_home_daikuan_sel",
                               nil];
    
    NSArray *titleArray = [NSArray arrayWithObjects:
                           @"纪念日",
                           @"故事墙",
                           @"相册集",
                           @"聊天吧",
                           nil];
    
    self.photoView.image = [UIImage imageNamed:imageNameArray[indexpath.row]];
    self.titleLabel.text = titleArray[indexpath.row];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
@end

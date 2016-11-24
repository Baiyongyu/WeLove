//
//  MemoryTwoCell.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/24.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "MemoryTwoCell.h"

@implementation MemoryTwoCell

+ (instancetype)memoryTwoCellWithTableView:(UITableView *)tableView {
    static NSString *Identifier = @"cell2";
    
    MemoryTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MemoryTwoCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

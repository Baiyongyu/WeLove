//
//  HomeFirstViewCell.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/13.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "HomeThirdViewCell.h"

@implementation HomeThirdViewCell

- (IBAction)btnClickAction:(id)sender {
    if (self.btnClickActionBlock) {
        self.btnClickActionBlock();
    }
}

- (IBAction)shareBtnAction:(id)sender {
    if (self.shareBtnActionBlock) {
        self.shareBtnActionBlock();
    }
}

+ (instancetype)homeThirdCellWithTableView:(UITableView *)tableView {
    static NSString *Identifier = @"cell";
    HomeThirdViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeThirdViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

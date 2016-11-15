//
//  DayTimeOneCell.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "DayTimeCell.h"

@interface DayTimeCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;

@end

@implementation DayTimeCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"DayTimeCell" bundle:nil];
}


- (void)refreshUIWithImageArray:(NSArray *)array time:(NSString *)time {
    self.timeLabel.text = time;
    
    if (array.count > 0) {
        self.imgView1.image = [UIImage imageNamed:array[0]];
    }
    
    if (array.count > 1) {
        self.imgView2.image = [UIImage imageNamed:array[1]];
    }
    
    if (array.count > 2) {
        self.imgView3.image = [UIImage imageNamed:array[2]];
    }
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

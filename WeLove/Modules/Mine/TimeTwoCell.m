//
//  TimeTwoCell.m
//  60730-TimeLine
//
//  Created by iOS_Chris on 16/7/30.
//  Copyright © 2016年 shu. All rights reserved.
//

#import "TimeTwoCell.h"

@interface TimeTwoCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;

@end

@implementation TimeTwoCell

+(UINib *)nib {
    return [UINib nibWithNibName:@"TimeTwoCell" bundle:nil];
}

- (void)refreshUIWithImageArray:(NSArray *)array
{
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

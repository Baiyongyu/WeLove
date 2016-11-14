//
//  ANZButton.m
//  anz
//
//  Created by KevinCao on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "QMButton.h"

@interface QMButton ()
@property(nonatomic,strong)UILabel *countLabel;
@end

@implementation QMButton
- (void) layoutSubviews
{
    [super layoutSubviews];
    if(self.relayout)
    {
        self.imageView.frame =self.imageViewFrame;
        self.titleLabel.frame=self.titleLabelFrame;
    }
}

#pragma mark - getters and setters
- (void)setMsgCount:(int)msgCount
{
    _msgCount = msgCount;
    if (msgCount) {
        if (!self.countLabel.superview) {
            [self addSubview:self.countLabel];
            WS(weakSelf);
            [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(16);
                make.center.equalTo(weakSelf);
                make.centerX.mas_equalTo(weakSelf.mas_right).offset(-self.msgCountOffset);
                make.centerY.mas_equalTo(weakSelf.mas_top).offset(self.msgCountOffset);
            }];
            self.countLabel.layer.cornerRadius = 8;
        }
        self.countLabel.text = [NSString stringWithFormat:@"%d",msgCount];
    } else {
        [_countLabel removeFromSuperview];
    }
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.clipsToBounds = YES;
        _countLabel.font = XiHeiFont(10);
    }
    return _countLabel;
}

@end

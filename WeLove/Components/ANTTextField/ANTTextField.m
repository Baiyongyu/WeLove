//
//  ANZTextField.m
//  anz
//
//  Created by KevinCao on 16/7/4.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANTTextField.h"

@implementation ANTTextField

- (id)initWithLeftTitle:(NSString *)leftTitle
{
    self = [super init];
    if (self) {
        CGSize titleSize = [QMUtil getSizeWithText:leftTitle font:XiHeiFont(14)];
        UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 40)];
        leftView.font = XiHeiFont(14);
        leftView.textColor = kDarkGrayColor;
        leftView.text = leftTitle;
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        line.backgroundColor = kBgLightGrayColor;
        WS(weakSelf);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (id)initWithLeftIcon:(NSString *)leftIcon
{
    self = [super init];
    if (self) {
        UIImage *leftImage = [UIImage imageNamed:leftIcon];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftImage.size.width+15, 40)];
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (leftView.height-leftImage.size.height)/2.0, leftImage.size.width, leftImage.size.height)];
        leftImageView.image = leftImage;
        [leftView addSubview:leftImageView];
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        line.backgroundColor = kBgLightGrayColor;
        WS(weakSelf);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

@end

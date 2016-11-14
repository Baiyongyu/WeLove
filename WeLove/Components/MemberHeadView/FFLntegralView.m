//
//  FFLntegralView.m
//  FFVipLevelProgressView
//
//  Created by Mr.Yao on 16/10/21.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import "FFLntegralView.h"
#import "FFNumberScrollView.h"

@interface FFLntegralView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FFNumberScrollView * numberView;
@property (nonatomic, strong) UILabel *tianLabel;

@end

@implementation FFLntegralView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.numberView];
    [self addSubview:self.tianLabel];
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self, -20)
    .topSpaceToView(self, 0)
    .heightIs(15);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.numberView.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self.titleLabel, 10)
    .autoHeightRatio(0.9)
    .widthIs(20)
    .heightIs(20);
    
    self.tianLabel.sd_layout
    .leftSpaceToView(self.numberView, 10)
    .topEqualToView(self.titleLabel)
    .heightIs(15);
    [self.tianLabel setSingleLineAutoResizeWithMaxWidth:30];
}

- (void)startAnimationWithNumber:(NSInteger)number{
    [self.numberView setValue:[NSNumber numberWithInteger:number]];
    [self.numberView startAnimation];
}

- (FFNumberScrollView *)numberView{
    if (!_numberView) {
        _numberView = [[FFNumberScrollView alloc]init];
        _numberView.textColor = [UIColor hexStringToColor:@"#ffd439"];
        _numberView.font = [UIFont fontWithName:@"Helvetica-Roman" size:18];
        _numberView.minLength = 1;
    }
    return _numberView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"在一起";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)tianLabel {
    if (!_tianLabel) {
        _tianLabel = [[UILabel alloc] init];
        _tianLabel.backgroundColor = [UIColor clearColor];
        _tianLabel.text = @"天";
        _tianLabel.font = [UIFont systemFontOfSize:15];
        _tianLabel.textColor = [UIColor whiteColor];
    }
    return _tianLabel;
}


@end

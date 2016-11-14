//
//  WishViewController.m
//  inongtian
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "WishViewController.h"
#import "DBSphereView.h"  // 3D球

@interface WishViewController ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *bottomView;
/** 3D球 */
@property (nonatomic, strong) DBSphereView *sphereView;
/** 标签 */
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation WishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"心愿球";
    self.leftBtn.hidden = NO;
}

- (void)layoutConstraints {
    [self.contentView addSubview:self.bgView];
    [self.bgView sd_addSubviews:@[self.bottomView]];
    
    self.bgView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    self.bottomView.sd_layout
    .leftSpaceToView(self.bgView, 22.5)
    .rightSpaceToView(self.bgView, 22.5)
    .bottomSpaceToView(self.bgView, 20)
    .heightIs(180);
}


#pragma mark - 加载3D球数据
- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"3DBallPlist" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *string = dict[@"online_params"][@"KeyWord"];
    _titleArray = [string componentsSeparatedByString:@","];
    
    // 3D球
    [self addShowTagView];
}

#pragma mark - 创建3D球形视图
- (void)addShowTagView {
    CGFloat bounds_Width = kScreenWidth - 60;
    _sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(30, 20, bounds_Width, bounds_Width)];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 50; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:_titleArray[i * 4 + arc4random()% 4] forState:UIControlStateNormal];
        [btn setTitleColor:[self randomColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.];
        btn.frame = CGRectMake(0, 0, 80, 20);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [_sphereView addSubview:btn];
    }
    [_sphereView setCloudTags:array];
    _sphereView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_sphereView];
}

- (void)buttonPressed:(UIButton *)btn {
    [_sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [_sphereView timerStart];
        }];
    }];
}

#pragma mark - 随机颜色
- (UIColor *)randomColor {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.image = [UIImage imageNamed:@"lbg41009"];
    }
    return _bgView;
}

- (UIImageView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIImageView new];
        _bottomView.image = [UIImage imageNamed:@"love_relation_mid_heart"];
    }
    return _bottomView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

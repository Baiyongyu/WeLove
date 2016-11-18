//
//  PhotosTypeViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/17.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "PhotosTypeViewController.h"

@interface PhotosTypeViewController ()
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation PhotosTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kNavColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self backButton];
    
    [self navigationTitle];
    
}

- (void)backButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 25, 50, 30);
    [backButton setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationTitle {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/2, 20, 80, 40)];
    _titleLabel.text = @"相册集";
    _titleLabel.font = XiHeiFont(18);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

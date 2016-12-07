//
//  ViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/1.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"LaunchImage-1224-2208h@3x"];;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MemoryDayViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "MemoryDayViewController.h"
#import "MemoryOneCell.h"
#import "MemoryTwoCell.h"


@interface MemoryDayViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MemoryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"纪念日";
    self.leftBtn.hidden = NO;
    [self.contentView addSubview:self.tableView];
}

- (void)layoutConstraints {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MemoryOneCell *cell = [MemoryOneCell memoryOneCellWithTableView:tableView];
        return cell;
    }
    
    MemoryTwoCell *cell = [MemoryTwoCell memoryTwoCellWithTableView:tableView];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

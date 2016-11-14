//
//  ComMineViewController.m
//  LoveMySmallV
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "MineViewController.h"
#import "ComDynamicHeadView.h"

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) ComDynamicHeadView *headView;
//头像
@property(nonatomic,strong)UIImageView *avatarView;
@property (nonatomic, assign) CGFloat lastOffset;
@property (nonatomic, assign) BOOL isShowWave;

@end

@implementation MineViewController

- (void)loadSubViews {
    
    [super loadSubViews];
    
    self.titleLabel.text = @"我们";
    [self.contentView addSubview:self.tableView];
    self.lastOffset = pictureHeight;
}

- (void)layoutConstraints {
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    // 添加头视图 在头视图上添加ImageView
    self.headView = [[ComDynamicHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, pictureHeight)];
    self.headView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.headView];
        
    // 头像
    _avatarView = [[UIImageView alloc] init];
    _avatarView.backgroundColor = [UIColor whiteColor];
    _avatarView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarView.layer.masksToBounds = YES;
    _avatarView.image = [UIImage imageNamed:@"echatIMG11.jpeg"];
}
- (void)loadData {
    self.titleArray = @[@"微爱",@"时光",@"聊天",@"设置"];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = XiHeiFont(16);
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) { //农场信息
        return;
    }
    if (indexPath.row==1) { //物联网
        return;
    }
    if (indexPath.row==2) { //关于爱农田
        return;
    }
    if (indexPath.row==3) { //设置
        return;
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.isShowWave) {
        [self.headView starWave];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (fabs(offsetY) > pictureHeight) {
        self.isShowWave = YES;
    }
    else {
        self.isShowWave = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.headView stopWave];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取到tableView偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat height = pictureHeight - (self.lastOffset + offsetY);
    
    if (height < NAV_HEIGHT) {
//        height = NAV_HEIGHT;
//                self.headView.navBar.alpha = 1;
    }
    else {
//                self.headView.navBar.alpha = 1 - height / pictureHeight;
    }
    
    self.headView.frame  = CGRectMake(0, -20, self.headView.frame.size.width, height);
    self.headView.imgView.frame = CGRectMake(0, 0, self.headView.frame.size.width, height);
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(pictureHeight, 0, 0, 0);
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

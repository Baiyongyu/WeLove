//
//  MineViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "MineViewController.h"
/** Nav */
#import "NavHeadTitleView.h"
/** headView */
#import "HeadImageView.h"

#import "WebViewController.h"
#import "PhotosTypeViewController.h"
#import "PhotoAlbumViewController.h"  // 左右滑动模式
#import "AlbumPhotosViewController.h" // 流式
#import "ListPhotoViewController.h"   // 列表
#import "CacheManager.h"

@interface MineViewController () <UITableViewDataSource,UITableViewDelegate,NavHeadTitleViewDelegate>
{
    //头像
    UIImageView *_headerImg;
    //昵称
    UILabel *_nickLabel;
}

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIImageView *backgroundImgV;//背景图
/** 头部 */
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,assign)float backImgOrgy;
@property(nonatomic,strong)NavHeadTitleView *NavView;//导航栏
@property(nonatomic,strong)HeadImageView *headImageView;//头视图
@property(nonatomic,assign)int rowHeight;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 拉伸顶部图片
    [self lashenBgView];
    // 创建导航栏
    [self createNav];
    // 创建TableView
    [self createTableView];
}
#pragma mark - 拉伸顶部图片
- (void)lashenBgView {
    
    _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    _backgroundImgV.image = [UIImage imageNamed:@"lbg41009"];
    _backgroundImgV.userInteractionEnabled = YES;
    _backImgHeight = _backgroundImgV.frame.size.height;
    _backImgWidth = _backgroundImgV.frame.size.width;
    _backImgOrgy = _backgroundImgV.frame.origin.y;
    [self.view addSubview:_backgroundImgV];
}
#pragma mark - 创建TableView
- (void)createTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    _tableView.tableHeaderView = self.headerView;
}

#pragma mark - 头视图
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 180)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        // 头像
        _headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame) - 40, 100, 100)];
        _headerImg.center = CGPointMake(kScreenWidth/2, 100);
        [_headerImg setImage:[UIImage imageNamed:@"WechatIMG11.jpeg"]];
        [_headerImg.layer setMasksToBounds:YES];
        [_headerImg.layer setCornerRadius:2.0f];
        [_headerImg.layer setBorderWidth:2.0f];
        [_headerImg.layer setBorderColor:[UIColor whiteColor].CGColor];
        _headerImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_headerImg addGestureRecognizer:tap];
        [_headerView addSubview:_headerImg];
        // 昵称
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(147, CGRectGetMaxY(_headerImg.frame) + 20, kScreenWidth - 20, 20)];
        _nickLabel.center = CGPointMake(kScreenWidth/2, 160);
        _nickLabel.text = @"◆◇、遇见你、是我今生最美好的相遇...";
        _nickLabel.textColor = kDarkGrayColor;
        _nickLabel.font = XiHeiFont(14);
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:_nickLabel];
    }
    return _headerView;
}


// 头像点击事件
- (void)tapClick:(UITapGestureRecognizer *)recognizer {
    NSLog(@"修改头像");
}

#pragma mark - 创建导航栏
- (void)createNav {
    self.NavView = [[NavHeadTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.NavView.title = @"个人中心";
    self.NavView.color = [UIColor whiteColor];
    self.NavView.rightTitleImage = @"Setting";
    self.NavView.delegate = self;
    [self.view addSubview:self.NavView];
}
// 右按钮回调
- (void)NavHeadToRight {
    NSLog(@"点击了右按钮");
}

#pragma mark ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"register_m_selected"];
        cell.textLabel.text = @"宇哥资料";
    }
    else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"register_f_selected"];
        cell.textLabel.text = @"小v资料";
    }
    else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"setting-9"];
        cell.textLabel.text = @"相册";
    }
    else if (indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"setting-2"];
        cell.textLabel.text = @"清理缓存";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 4) {
        cell.imageView.image = [UIImage imageNamed:@"profile_3"];
        cell.textLabel.text = @"我们的家乡";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
    }
    
    if (indexPath.row == 3) {
        
        [UIAlertController showAlertInViewController:self withTitle:@"清理缓存" message:[NSString stringWithFormat:@"缓存大小为%.2fM,确定要清理缓存吗?", [[CacheManager sharedCacheManager] cacheFileSize]] cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == controller.destructiveButtonIndex) {
                
                [[CacheManager sharedCacheManager] clearCache];
            }
        }];
    }
    if (indexPath.row == 4) {
        ComWebViewController *webVC = [[ComWebViewController alloc] init];
        webVC.urlStr = @"http://h5.eqxiu.com/s/NABANe?eqrcode=1&from=timeline&isappinstalled=0";
        [kRootNavigation pushViewController:webVC animated:YES];
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}


#pragma mark - 导航栏渐变效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y <= 170) {
        self.NavView.headBgView.alpha = scrollView.contentOffset.y/170;
        self.NavView.rightImageView = @"Setting";
        self.NavView.color = [UIColor whiteColor];
        //状态栏字体白色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else {
        self.NavView.headBgView.alpha = 1;
        self.NavView.rightImageView = @"Setting-click";
        self.NavView.color = kNavColor;
        //隐藏黑线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        // 状态栏字体黑色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    if (contentOffsety < 0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight - contentOffsety;
        rect.size.width = _backImgWidth * (_backImgHeight - contentOffsety)/_backImgHeight;
        rect.origin.x = -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _backgroundImgV.frame = rect;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

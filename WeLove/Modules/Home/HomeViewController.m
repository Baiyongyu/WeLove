//
//  HomeViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/7.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderBannerView.h"
#import "HomeHeaderCardView.h"
#import "AudioStreamer.h"   // 播放音乐

#import "HomeFirstViewCell.h"
#import "HomeSecondViewCell.h"
#import "HomeThirdViewCell.h"

#import "FirstCellDetailController.h"
#import "LoversSpaceViewController.h"

#import "JSShareView.h"

static NSString *identifier = @"firstCell";

@interface HomeViewController () <UIScrollViewDelegate,DidSeletedViewItemDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AudioStreamer *streamer;
}
@property (nonatomic, strong) UIView *headerBgView;
@property (nonatomic, strong) HomeHeaderBannerView *headerBannerView;
@property (nonatomic, strong) HomeHeaderCardView *headerCardView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

BOOL isPlay = YES;

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"首页";
    [self.headerBgView addSubview:self.headerBannerView];
    [self.headerBgView addSubview:self.headerCardView];
    [self.contentView addSubview:self.tableView];

    // 背景音乐
    self.animaImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animaAction:)];
    [self.animaImg addGestureRecognizer:tap];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        HomeFirstViewCell *cell = [HomeFirstViewCell homeFirstCellWithTableView:tableView];
        cell.btnClickActionBlock = ^{
            
            FirstCellDetailController *firstVC = [[FirstCellDetailController alloc] init];
            [kRootNavigation pushViewController:firstVC animated:YES];
        };
        cell.detail.text = [NSString stringWithFormat:@"%@%@%@", @"我们在一起", [QMUtil getUTCFormateDate:@"2016-10-26 00:00"], @"天啦！"];
        cell.shareBtnActionBlock = ^{
            [JSShareView showShareViewWithPublishContent:@{@"text" :@"传入文字",
                                                           @"image":@"传入 url or image ",
                                                           @"url"  :@"传入链接"}
                                                  Result:^(ShareType type, BOOL isSuccess) {
                                                      //回调
                                                  }];
        };
        return cell;
    }
    if (indexPath.section == 1) {
        HomeSecondViewCell *cell = [HomeSecondViewCell homeSecondCellWithTableView:tableView];
        cell.btnClickActionBlock = ^{
            
            LoversSpaceViewController *loversVC = [[LoversSpaceViewController alloc] init];
            [kRootNavigation pushViewController:loversVC animated:YES];
        };
        cell.shareBtnActionBlock = ^{
            [JSShareView showShareViewWithPublishContent:@{@"text" :@"传入文字",
                                                           @"image":@"传入 url or image ",
                                                           @"url"  :@"传入链接"}
                                                  Result:^(ShareType type, BOOL isSuccess) {
                                                      //回调
                                                  }];
        };
        return cell;
    }
    HomeThirdViewCell *cell = [HomeThirdViewCell homeThirdCellWithTableView:tableView];
    cell.btnClickActionBlock = ^{
        
        FirstCellDetailController *firstVC = [[FirstCellDetailController alloc] init];
        [kRootNavigation pushViewController:firstVC animated:YES];
    };
    cell.shareBtnActionBlock = ^{
        [JSShareView showShareViewWithPublishContent:@{@"text" :@"传入文字",
                                                       @"image":@"传入 url or image ",
                                                       @"url"  :@"传入链接"}
                                              Result:^(ShareType type, BOOL isSuccess) {
                                                  //回调
                                              }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 245;
    }
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 10;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        LoversSpaceViewController *loversvc = [[LoversSpaceViewController alloc] init];
        [kRootNavigation pushViewController:loversvc animated:YES];
    }else {
        FirstCellDetailController *firstVC = [[FirstCellDetailController alloc] init];
        [kRootNavigation pushViewController:firstVC animated:YES];
    }
}
#pragma mark - 首页热门推荐item 代理
- (void)didSeletedViewItem:(NSIndexPath *)indexPath {
}

#pragma mark - 点击播放音符
- (void)animaAction:(UITapGestureRecognizer *)tap {
    
    if (isPlay == YES) {
        if (!streamer) {
            [self createStreamer];
        }
        [streamer start];
        
        [self creatAnimation];
        isPlay = NO;
    } else {
        [streamer pause];
        [self animationStop];
        isPlay = YES;
    }
}

- (void)createStreamer {
    [self destroyStreamer];
    
    NSURL *musicUrl = [NSURL URLWithString:kBackMusicPathUrl];
    NSString *str = musicUrl.absoluteString;
    
    NSString *escapedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)str, NULL, NULL, kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:escapedValue];
    streamer = [[AudioStreamer alloc] initWithURL:url];
}

- (void)destroyStreamer {
    if (streamer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASStatusChangedNotification object:streamer];
        
        [streamer stop];
        streamer = nil;
    }
}

#pragma mark - 音符旋转动画
- (void)creatAnimation {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:10];
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationDelegate:self.animaImg];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    self.animaImg.transform = CGAffineTransformRotate(self.animaImg.transform, M_PI);
    [UIView commitAnimations];
}
// 动画结束
- (void)animationStop {
    CGPoint center = self.animaImg.center;
    self.animaImg.center = center;
    //将transForm进行还原
    self.animaImg.transform = CGAffineTransformIdentity;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerBgView;
        _tableView.tableFooterView = [self tableViewFooterView];
    }
    return _tableView;
}

- (UIView *)tableViewFooterView {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    
    UILabel *bottomlabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 10, 200, 12)];
    bottomlabel.text = @"- 我是有底线的 -";
    bottomlabel.font = XiHeiFont(13);
    bottomlabel.textAlignment = NSTextAlignmentCenter;
    [tableFooterView addSubview:bottomlabel];
    return tableFooterView;
}

- (UIView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 + 88 + 260)];
        _headerBgView.backgroundColor = [UIColor clearColor];
        _headerBgView.userInteractionEnabled = YES;
    }
    return _headerBgView;
}

- (HomeHeaderBannerView *)headerBannerView {
    if (!_headerBannerView) {
        _headerBannerView = [[HomeHeaderBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 + 88)];
        _headerBannerView.backgroundColor = [UIColor clearColor];
    }
    return _headerBannerView;
}

- (HomeHeaderCardView *)headerCardView {
    if (!_headerCardView) {
        _headerCardView = [[HomeHeaderCardView alloc] initWithFrame:CGRectMake(0, 140 + 88, kScreenWidth, 260)];
        _headerCardView.backgroundColor = [UIColor clearColor];
        _headerCardView.delegate = self;
    }
    return _headerCardView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

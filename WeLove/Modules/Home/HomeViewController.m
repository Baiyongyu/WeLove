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

@interface HomeViewController () <UIScrollViewDelegate,DidSeletedViewItemDelegate>
{
    AudioStreamer *streamer;
}
@property (nonatomic, strong) UIView *headerBgView;
@property (nonatomic, strong) HomeHeaderBannerView *headerBannerView;
@property (nonatomic, strong) HomeHeaderCardView *headerCardView;
@end

BOOL isPlay = YES;

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"首页";
    [self.headerBgView addSubview:self.headerBannerView];
    [self.headerBgView addSubview:self.headerCardView];
    [self.contentView addSubview:self.headerBgView];
    
    // 背景音乐
    self.animaImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animaAction:)];
    [self.animaImg addGestureRecognizer:tap];
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
    
    NSURL *musicUrl = [NSURL URLWithString:@"http://cdn.y.baidu.com/746dd400ec21750107a8cfd227d999f0.mp3"];
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


- (UIView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140 + 88 + 300)];
        _headerBgView.backgroundColor = [UIColor clearColor];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

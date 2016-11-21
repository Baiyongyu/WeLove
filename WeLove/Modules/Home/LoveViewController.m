//
//  LoveViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "LoveViewController.h"
#import "HomeWeatherView.h"         // 天气
#import "AnimaViewController.h"     // 动画
#import "ComAnimationLayer.h"
#import "MemoryDayViewController.h" // 纪念日
#import "WishViewController.h"      // 心愿
#import "PhotosTypeViewController.h"// 相册集
#import "MusicListViewController.h" // 音乐库

#import "PhotoAlbumViewController.h"  // 左右滑动模式
#import "AlbumPhotosViewController.h" // 流式
#import "ListPhotoViewController.h"   // 列表

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface LoveViewController ()
{
    UIView *bgViewContainer;
    UIButton *_centerButton;
    AVAudioPlayer *_audioPlayer;
}
//天气
@property(nonatomic,strong)HomeWeatherView *weatherView;
@end

BOOL isPlay = YES;

@implementation LoveViewController

#pragma mark - life style
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.weatherView updateDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 天气
    [self.bgShadowView addSubview:self.weatherView];
    // 设置一排固定间距自动宽度子view
    [self setupAutoWidthViewsWithCount:4 margin:10];
    // 小头像
    self.meImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.vImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    // 背景音乐
    self.animaImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animaAction:)];
    [self.animaImg addGestureRecognizer:tap];
}

#pragma mark - 设置一排固定间距自动宽度子view
- (void)setupAutoWidthViewsWithCount:(NSInteger)count margin:(CGFloat)margin {
    
    bgViewContainer = [UIView new];
    bgViewContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgViewContainer];
    
    NSMutableArray *temp = [NSMutableArray new];
    
    NSArray *titleArray = @[@"纪念日", @"心愿球", @"相册集", @"音乐库"];
    NSArray *imgArray = @[@"indexPageIconAnni_26x26_", @"indexPageIconWish_26x26_", @"indexPageIconClock_26x26_", @"indexPageIconPunch_26x26_"];
    for (int i = 0; i < count; i++) {
        _centerButton = [UIButton new];
        [_centerButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [_centerButton setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        [_centerButton setBackgroundImage:[UIImage imageNamed:@"indexPageBgSquare_89x74_"] forState:UIControlStateNormal];
        _centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _centerButton.titleLabel.font = XiHeiFont(10);
        _centerButton.tag = i + 1;
        [_centerButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_centerButton setTitleColor:kLightGrayColor forState:UIControlStateNormal];
        _centerButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [bgViewContainer addSubview:_centerButton];
        
        _centerButton.sd_layout.autoHeightRatio(0.8);
        [temp addObject:_centerButton];
        
        _centerButton.sd_layout
        .centerXEqualToView(bgViewContainer)
        .topSpaceToView(bgViewContainer, 5)
        .widthRatioToView(bgViewContainer, 0.5)
        .heightIs(60);
        
        // 设置button的图片的约束
        _centerButton.imageView.sd_layout
        .widthRatioToView(_centerButton, 0.8)
        .topSpaceToView(_centerButton, 10)
        .centerXEqualToView(_centerButton)
        .heightRatioToView(_centerButton, 0.4);
        
        // 设置button的label的约束
        _centerButton.titleLabel.sd_layout
        .topSpaceToView(_centerButton.imageView, 5)
        .leftEqualToView(_centerButton.imageView)
        .rightEqualToView(_centerButton.imageView)
        .bottomSpaceToView(_centerButton, 10);
    }
    
    bgViewContainer.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 69);
    
    // 此步设置之后_autoWidthViewsContainer的高度可以根据子view自适应
    [bgViewContainer setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:margin horizontalMargin:margin verticalEdgeInset:5 horizontalEdgeInset:10];
}

#pragma mark - 首页下方按钮组事件
- (void)chooseAction:(UIButton *)btn {
    if (btn.tag == 1) {
        MemoryDayViewController *memoryVC = [[MemoryDayViewController alloc] init];
        [kRootNavigation pushViewController:memoryVC animated:YES];
    }
    else if (btn.tag == 2) {
        WishViewController *wishVC = [[WishViewController alloc] init];
        [kRootNavigation pushViewController:wishVC animated:YES];
    }
    else if (btn.tag == 3) {
        PhotosTypeViewController *typeVC = [[PhotosTypeViewController alloc] initWithViewControllerClasses:@[[PhotoAlbumViewController class], [ListPhotoViewController class], [AlbumPhotosViewController class]] andTheirTitles:@[@"陌陌模式", @"列表相册", @"流式相册"]];
        typeVC.menuViewStyle = WMMenuViewStyleLine;
        typeVC.menuItemWidth = 80;
        typeVC.menuBGColor= [UIColor whiteColor];
        typeVC.menuHeight = 40;
        typeVC.titleColorSelected = kNavColor;
        typeVC.titleSizeNormal = 14;
        typeVC.titleSizeSelected = 14;
        
        [self.navigationController pushViewController:typeVC animated:YES];
    }
    else if (btn.tag == 4) {
        MusicListViewController *musicVC = [[MusicListViewController alloc] init];
        [kRootNavigation pushViewController:musicVC animated:YES];
    }
}

#pragma mark - 点击播放音符
- (void)animaAction:(UITapGestureRecognizer *)tap {
    if (isPlay == YES) {
        // 音乐播放
        [self MP3Player];
        [_audioPlayer play];
        [self creatAnimation];
        isPlay = NO;
    } else {
        [_audioPlayer pause];
        [self animationStop];
        isPlay = YES;
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

#pragma mark - 音乐播放
- (void)MP3Player {
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //播放背景音乐
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"齐晨-咱们结婚吧" ofType:@"mp3"];
//    NSURL *url = [[NSURL alloc] initWithString:@"http://music.163.com/outchain/player?type=2&id=28029509&auto=1&height=66"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    // 创建播放器
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audioPlayer prepareToPlay];
    [_audioPlayer setVolume:1];
    _audioPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
//    [_audioPlayer play]; //播放
    
    [self setLockScreenNowPlayingInfo];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                [_audioPlayer pause];
                NSLog(@"RemoteControlEvents: pause");
                break;
            case UIEventSubtypeRemoteControlPlay:
                [_audioPlayer play];
                NSLog(@"RemoteControlEvents: play");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [_audioPlayer play];
                NSLog(@"RemoteControlEvents: playModeNext");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [_audioPlayer play];
                NSLog(@"RemoteControlEvents: playPrev");
                break;
            default:
                break;
        }
    }
}

- (void)setLockScreenNowPlayingInfo {
    //更新锁屏时的歌曲信息
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:@"歌曲名111" forKey:MPMediaItemPropertyTitle];
        [dict setObject:@"演唱者1111" forKey:MPMediaItemPropertyArtist];
        [dict setObject:@"专辑名1111" forKey:MPMediaItemPropertyAlbumTitle];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

- (HomeWeatherView *)weatherView {
    if (!_weatherView) {
        _weatherView = [[HomeWeatherView alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, 170)];
    }
    return _weatherView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LoveViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "LoveViewController.h"
#import "HomeDateView.h"            // 天气
#import "AnimaViewController.h"     // 动画
#import "ComAnimationLayer.h"
#import "MemoryDayViewController.h" // 纪念日
#import "WishViewController.h"      // 心愿
#import "PhotosTypeViewController.h"// 相册集
#import "ChatListViewController.h"  // 聊天吧

#import "LoversViewController.h"      // 情侣空间
#import "PhotoAlbumViewController.h"  // 左右滑动模式
#import "AlbumPhotosViewController.h" // 流式
#import "ListPhotoViewController.h"   // 列表

#import "AudioStreamer.h"   // 播放音乐

@interface LoveViewController () 
{
    UIView *bgViewContainer;
    UIButton *_centerButton;
    AudioStreamer *streamer;
}
//天气
@property(nonatomic,strong)HomeDateView *dateView;
@end

BOOL isPlay = YES;

@implementation LoveViewController

#pragma mark - life style
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.dateView updateDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 天气
    [self.bgShadowView addSubview:self.dateView];
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
    
    NSArray *titleArray = @[@"纪念日", @"故事球", @"相册集", @"聊天吧"];
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
        PhotosTypeViewController *typeVC = [[PhotosTypeViewController alloc] initWithViewControllerClasses:@[[LoversViewController class], [PhotoAlbumViewController class], [ListPhotoViewController class], [AlbumPhotosViewController class]] andTheirTitles:@[@"情侣相册", @"陌陌模式", @"列表相册", @"流式相册"]];
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
        
        
        [UIAlertController showActionSheetInViewController:self withTitle:@"选择登录账户" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"宇哥",@"小v"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == controller.firstOtherButtonIndex) {
                NSString *token = RONGCLOUD_TokenY;
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    NSLog(@"Login successfully with userId: %@.", userId);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 登录成功之后，跳转到主页面
                        NSLog(@"登录成功");
                        //                [MBProgressHUD showTip:@"登录成功"];
                        ChatListViewController *chatVC = [[ChatListViewController alloc] init];
                        [kRootNavigation pushViewController:chatVC animated:YES];
                    });
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"login error status: %ld.", (long)status);
                } tokenIncorrect:^{
                    NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
                }];
            }else if (buttonIndex == controller.secondOtherButtonIndex) {
                NSString *token = RONGCLOUD_TokenW;
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    NSLog(@"Login successfully with userId: %@.", userId);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 登录成功之后，跳转到主页面
                        NSLog(@"登录成功");
                        //                [MBProgressHUD showTip:@"登录成功"];
                        ChatListViewController *chatVC = [[ChatListViewController alloc] init];
                        [kRootNavigation pushViewController:chatVC animated:YES];
                        
                    });
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"login error status: %ld.", (long)status);
                } tokenIncorrect:^{
                    NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
                }];
            }
        }];
    }
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


- (HomeDateView *)dateView {
    if (!_dateView) {
        _dateView = [[HomeDateView alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, 170)];
    }
    return _dateView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

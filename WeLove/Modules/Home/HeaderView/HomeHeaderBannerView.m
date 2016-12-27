//
//  HomeHeaderView.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/7.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "HomeHeaderBannerView.h"
#import "SDCycleScrollView.h"               // 滚动视图
#import "QMNavigateCollectionViewCell.h"
#import "MemoryDayViewController.h" // 纪念日
#import "WishViewController.h"      // 心愿

#import "LoversSpaceViewController.h"
#import "PhotosTypeViewController.h"// 相册集
#import "ChatListViewController.h"  // 聊天吧
#import "LoversViewController.h"      // 情侣空间
#import "PhotoAlbumViewController.h"  // 左右滑动模式
#import "AlbumPhotosViewController.h" // 流式
#import "ListPhotoViewController.h"   // 列表

@interface HomeHeaderBannerView () <SDCycleScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
/** 背景 */
@property (nonatomic, strong) UIView *bgView;
/** banner */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** collection背景图 */
@property (nonatomic, strong) UIImageView *bgImgView;
/** collevtionView */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HomeHeaderBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutConstraints];
    }
    return self;
}

- (void)layoutConstraints {
    
    /** 头视图 背景View */
    [self addSubview:self.bgView];
    /** ScrollView */
    [self.bgView addSubview:self.cycleScrollView];
    /** collection */
    [self.bgView addSubview:self.bgImgView];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index=%ld", index);
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.urlStr = @"http://h5.eqxiu.com/s/NABANe?eqrcode=1&from=timeline&isappinstalled=0";
    [kRootNavigation pushViewController:webVC animated:YES];
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMNavigateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NavCell" forIndexPath:indexPath];
    [cell setImageForCellWithIndexpath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            MemoryDayViewController *memoryVC = [[MemoryDayViewController alloc] init];
            [kRootNavigation pushViewController:memoryVC animated:YES];
        }
            break;
        case 1: {
            WishViewController *wishVC = [[WishViewController alloc] init];
            [kRootNavigation pushViewController:wishVC animated:YES];
        }
            break;
        case 2: {
            LoversSpaceViewController *spaceVC = [[LoversSpaceViewController alloc] init];
            [kRootNavigation pushViewController:spaceVC animated:YES];
        }
            break;
        case 3: {
            
            [UIAlertController showActionSheetInViewController:kRootNavigation withTitle:@"选择登录账户" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"宇哥",@"小v"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex == controller.firstOtherButtonIndex) {
                    NSString *token = RONGCLOUD_TokenY;
                    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                        NSLog(@"Login successfully with userId: %@.", userId);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 登录成功之后，跳转到主页面
                            ChatListViewController *chatVC = [[ChatListViewController alloc] init];
                            [MBProgressHUD showTip:@"登录成功、老婆么么哒😘"];
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
                            ChatListViewController *chatVC = [[ChatListViewController alloc] init];
                            [MBProgressHUD showTip:@"登录成功、老公么么哒😘"];
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
            break;
        default:
            break;
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160 + 88)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 160) delegate:self placeholderImage:[UIImage imageNamed:@"no_feed_content"]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.autoScrollTimeInterval = 3;
        
        NSArray *imgArray = @[@"http://img.zngirls.com/gallery/21337/17758/003.jpg",
                              @"http://img.zngirls.com/gallery/19705/19815/004.jpg"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _cycleScrollView.imageURLStringsGroup = imgArray;
        });
        
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
    }
    return _cycleScrollView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, 88)];
        _bgImgView.image = [UIImage imageNamed:@"icon_arc+rectangle8"];
        _bgImgView.contentMode = UIViewContentModeScaleToFill;
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.alpha = 0.8f;
        _bgImgView.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 88) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth/4, 88);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"QMNavigateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NavCell"];
        [_bgImgView addSubview:_collectionView];
    }
    return _bgImgView;
}

@end

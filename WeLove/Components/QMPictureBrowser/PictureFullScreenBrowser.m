//
//  QMFullScreenPictureBrowser.m
//  inongtian
//
//  Created by KevinCao on 2016/10/26.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "PictureFullScreenBrowser.h"
#import "QMPictureView.h"

@interface PictureFullScreenBrowser () <UIScrollViewDelegate, QMPictureViewDelegate>
/// 图片数组，3个 UIImageView。进行复用
@property (nonatomic, strong) NSMutableArray<QMPictureView *> *pictureViews;
/// 准备待用的图片视图（缓存）
@property (nonatomic, strong) NSMutableArray<QMPictureView *> *readyToUsePictureViews;
/// 图片张数
@property (nonatomic, assign) NSInteger picturesCount;
/// 当前页数
@property (nonatomic, assign) NSInteger currentPage;
/// 界面子控件
@property (nonatomic, strong) UIScrollView *scrollView;
/// 页码文字控件
@property (nonatomic, strong) UILabel *pageTextLabel;
/// 消失的 tap 手势
@property (nonatomic, weak) UITapGestureRecognizer *dismissTapGes;
//内容视图
@property(nonatomic,strong)UIView *contentView;
//背景
@property(nonatomic,strong)UIImageView *bgView;
@end

@implementation PictureFullScreenBrowser

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self layoutConstraints];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange
{
    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    // 计算 scrollView 的 contentSize
    self.scrollView.contentSize = CGSizeMake(self.picturesCount * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    // 滚动到指定位置
    [self.scrollView setContentOffset:CGPointMake(self.currentPage * self.scrollView.frame.size.width, 0) animated:false];
    for (QMPictureView *pictureView in self.pictureViews) {
        [self setPictureView:pictureView];
    }
}

- (void)setupUI {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageTextLabel];
    
    // 设置默认属性
    self.betweenImagesSpacing = 20;
    self.pageTextFont = [UIFont systemFontOfSize:16];
    self.pageTextCenter = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 20);
    self.pageTextColor = [UIColor whiteColor];
    // 初始化数组
    self.pictureViews = [NSMutableArray array];
    self.readyToUsePictureViews = [NSMutableArray array];
    
    // 添加手势事件
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longGes];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self.view addGestureRecognizer:tapGes];
    self.dismissTapGes = tapGes;
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(-_betweenImagesSpacing * 0.5);
        make.top.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).offset(_betweenImagesSpacing);
        make.height.equalTo(weakSelf.view);
    }];
    [self.pageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.mas_equalTo(weakSelf.view.mas_bottom).offset(-20);
        make.width.mas_greaterThanOrEqualTo(60);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    [self.view setNeedsUpdateConstraints];
}

- (void)showFormView:(UIView *)fromView picturesCount:(NSInteger)picturesCount currentPictureIndex:(NSInteger)currentPictureIndex {
    
    NSString *errorStr = [NSString stringWithFormat:@"Parameter is not correct, pictureCount is %zd, currentPictureIndex is %zd", picturesCount, currentPictureIndex];
    NSAssert(picturesCount > 0 && currentPictureIndex < picturesCount, errorStr);
    NSAssert(self.delegate != nil, @"Please set up delegate for pictureBrowser");
    // 记录值并设置位置
    self.picturesCount = picturesCount;
    self.currentPage = currentPictureIndex;
    [self setPageText:currentPictureIndex];

    [kRootNavigation pushViewController:self animated:NO];
    // 计算 scrollView 的 contentSize
    self.scrollView.contentSize = CGSizeMake(picturesCount * _scrollView.frame.size.width, _scrollView.frame.size.height);
    // 滚动到指定位置
    [self.scrollView setContentOffset:CGPointMake(currentPictureIndex * _scrollView.frame.size.width, 0) animated:false];
    // 设置第1个 view 的位置以及大小
    QMPictureView *pictureView = [self setPictureViewForIndex:currentPictureIndex];
    // 获取来源图片在屏幕上的位置
    CGRect rect = [fromView convertRect:fromView.bounds toView:nil];
    
    [pictureView animationShowWithFromRect:rect animationBlock:^{
        self.contentView.backgroundColor = [UIColor blackColor];
        self.pageTextLabel.alpha = 1;
    } completionBlock:^{
        // 设置左边与右边的 pictureView
        if (currentPictureIndex != 0 && picturesCount > 1) {
            // 设置左边
            [self setPictureViewForIndex:currentPictureIndex - 1];
        }
        
        if (currentPictureIndex < picturesCount - 1) {
            // 设置右边
            [self setPictureViewForIndex:currentPictureIndex + 1];
        }
    }];
}

- (void)dismiss {
    if ([[UIDevice currentDevice] orientation]!=UIDeviceOrientationPortrait) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIDeviceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
    UIView *endView = [_delegate pictureView:self viewForIndex:_currentPage];
    CGRect rect = [endView convertRect:endView.bounds toView:[UIApplication sharedApplication].keyWindow];
    // 取到当前显示的 pictureView
    QMPictureView *pictureView = [[_pictureViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d", _currentPage]] firstObject];
    // 取消所有的下载
    for (QMPictureView *pictureView in _pictureViews) {
        [pictureView.imageView sd_cancelCurrentImageLoad];
    }
    
    for (QMPictureView *pictureView in _readyToUsePictureViews) {
        [pictureView.imageView sd_cancelCurrentImageLoad];
    }
    
    // 执行关闭动画
    [pictureView animationDismissWithToRect:rect animationBlock:^{
        self.contentView.backgroundColor = [UIColor clearColor];
        self.pageTextLabel.alpha = 0;
    } completionBlock:^{
        [kRootNavigation popViewControllerAnimated:NO];
    }];
}

#pragma mark - 监听事件

- (void)tapGes:(UITapGestureRecognizer *)ges {
    [self dismiss];
}

- (void)longPress:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateEnded) {
        if (self.longPressBlock) {
            self.longPressBlock(_currentPage);
        }
    }
}

#pragma mark - 私有方法

- (void)setPageTextFont:(UIFont *)pageTextFont {
    _pageTextFont = pageTextFont;
    self.pageTextLabel.font = pageTextFont;
}

- (void)setPageTextColor:(UIColor *)pageTextColor {
    _pageTextColor = pageTextColor;
    self.pageTextLabel.textColor = pageTextColor;
}

- (void)setPageTextCenter:(CGPoint)pageTextCenter {
    _pageTextCenter = pageTextCenter;
    [self.pageTextLabel sizeToFit];
    self.pageTextLabel.center = pageTextCenter;
}

- (void)setBetweenImagesSpacing:(CGFloat)betweenImagesSpacing {
    _betweenImagesSpacing = betweenImagesSpacing;
    self.scrollView.frame = CGRectMake(-_betweenImagesSpacing * 0.5, 0, self.view.frame.size.width + _betweenImagesSpacing, self.view.frame.size.height);
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage) {
        return;
    }
    NSUInteger oldValue = _currentPage;
    _currentPage = currentPage;
    [self removeViewToReUse];
    [self setPageText:currentPage];
    // 如果新值大于旧值
    if (currentPage > oldValue) {
        // 往右滑，设置右边的视图
        if (currentPage + 1 < _picturesCount) {
            [self setPictureViewForIndex:currentPage + 1];
        }
    }else {
        // 往左滑，设置左边的视图
        if (currentPage > 0) {
            [self setPictureViewForIndex:currentPage - 1];
        }
    }
    
}

/**
 设置pitureView到指定位置
 
 @param index 索引
 
 @return 当前设置的控件
 */
- (QMPictureView *)setPictureViewForIndex:(NSInteger)index {
    [self removeViewToReUse];
    QMPictureView *view = [self getPhotoView];
    view.index = index;
    [self setPictureView:view];
    return view;
}


- (void)setPictureView:(QMPictureView *)view
{
    CGRect frame = view.frame;
    frame.size = self.view.frame.size;
    view.frame = frame;
    
    // 设置图片的大小<在下载完毕之后会根据下载的图片计算大小>
    CGSize defaultSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    void(^setImageSizeBlock)(UIImage *) = ^(UIImage *image) {
        if (image != nil) {
            if (image != nil) {
                view.pictureSize = image.size;
            }else {
                view.pictureSize = defaultSize;
            }
        }
    };
    
    // 1. 判断是否实现图片大小的方法
    if ([_delegate respondsToSelector:@selector(pictureView:imageSizeForIndex:)]) {
        view.pictureSize = [_delegate pictureView:self imageSizeForIndex:view.index];
    }else if ([_delegate respondsToSelector:@selector(pictureView:defaultImageForIndex:)]) {
        UIImage *image = [_delegate pictureView:self defaultImageForIndex:view.index];
        // 2. 如果没有实现，判断是否有默认图片，获取默认图片大小
        setImageSizeBlock(image);
    } else if ([_delegate respondsToSelector:@selector(pictureView:viewForIndex:)]) {
        UIView *v = [_delegate pictureView:self viewForIndex:view.index];
        if ([v isKindOfClass:[UIImageView class]]) {
            UIImage *image = ((UIImageView *)v).image;
            setImageSizeBlock(image);
            // 并且设置占位图片
            view.placeholderImage = image;
        }
    }else {
        // 3. 如果都没有就设置为屏幕宽度，待下载完成之后再次计算
        view.pictureSize = defaultSize;
    }
    
    // 设置占位图
    if ([_delegate respondsToSelector:@selector(pictureView:defaultImageForIndex:)]) {
        view.placeholderImage = [_delegate pictureView:self defaultImageForIndex:view.index];
    }
    
    view.urlString = [_delegate pictureView:self highQualityUrlStringForIndex:view.index];
    
    CGPoint center = view.center;
    center.x = view.index * _scrollView.frame.size.width + _scrollView.frame.size.width * 0.5;
    view.center = center;
    view.imageView.center = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height * 0.5);
}

/**
 获取图片控件：如果缓存里面有，那就从缓存里面取，没有就创建
 
 @return 图片控件
 */
- (QMPictureView *)getPhotoView {
    QMPictureView *view;
    if (_readyToUsePictureViews.count == 0) {
        view = [QMPictureView new];
        // 手势事件冲突处理
        [self.dismissTapGes requireGestureRecognizerToFail:view.imageView.gestureRecognizers.firstObject];
        view.pictureDelegate = self;
    }else {
        view = [_readyToUsePictureViews firstObject];
        [_readyToUsePictureViews removeObjectAtIndex:0];
    }
    if (!view.superview) {
        [_scrollView addSubview:view];
        [_pictureViews addObject:view];
    }
    return view;
}


/**
 移动到超出屏幕的视图到可重用数组里面去
 */
- (void)removeViewToReUse {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (QMPictureView *view in self.pictureViews) {
        // 判断某个view的页数与当前页数相差值为2的话，那么让这个view从视图上移除
        if (abs((int)view.index - (int)_currentPage) == 2){
            [tempArray addObject:view];
            [view removeFromSuperview];
            [_readyToUsePictureViews addObject:view];
        }
    }
    [self.pictureViews removeObjectsInArray:tempArray];
}

/**
 设置文字，并设置位置
 */
- (void)setPageText:(NSUInteger)index {
    _pageTextLabel.text = [NSString stringWithFormat:@"%zd / %zd", index + 1, self.picturesCount];
    [_pageTextLabel sizeToFit];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger page = (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
    self.currentPage = page;
}

#pragma mark - ESPictureViewDelegate

- (void)pictureViewTouch:(QMPictureView *)pictureView {
//    [self dismiss];
}
- (void)pictureView:(QMPictureView *)pictureView scale:(CGFloat)scale {
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1 - scale];
}

#pragma mark - getters and setters
-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [QMUtil screenShot:[UIApplication sharedApplication].keyWindow];
    }
    return _bgView;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.pagingEnabled = true;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UILabel *)pageTextLabel
{
    if (!_pageTextLabel) {
        _pageTextLabel = [[UILabel alloc] init];
        _pageTextLabel.alpha = 0;
        _pageTextLabel.textColor = self.pageTextColor;
        _pageTextLabel.font = self.pageTextFont;
        _pageTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageTextLabel;
}

@end

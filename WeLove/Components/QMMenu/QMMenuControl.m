//
//  ANZMenuControl.m
//  anz
//
//  Created by KevinCao on 16/7/19.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "QMMenuControl.h"

@interface QMMenuControl () <UIScrollViewDelegate>
/** 标题栏 */
@property (nonatomic,strong)UIScrollView *titleScrollView;
/** 下面的内容栏 */
@property (nonatomic,strong)UIScrollView *contentScrollView;
@property(nonatomic,strong)UITableViewController *needScrollToTopPage;
@property(nonatomic,retain,readwrite)NSMutableArray *childViewControllers;
@property(nonatomic,strong)UIView *menuIndicator;
@end

@implementation QMMenuControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleScrollView];
        [self addSubview:self.contentScrollView];
        [self.titleScrollView addSubview:self.menuIndicator];
//        [self layoutConstraints];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    WS(weakSelf);
//    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(weakSelf);
//        make.height.mas_equalTo(40);
//    }];
//    
//    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(weakSelf);
//        make.top.mas_equalTo(weakSelf.titleScrollView.mas_bottom);
//    }];
    
    self.titleScrollView.frame = CGRectMake(0, 0, self.width, 40);
    self.contentScrollView.frame = CGRectMake(0, self.titleScrollView.bottom, self.width, self.height-self.titleScrollView.height);
}

- (void)addChildViewController:(UIViewController *)viewController
{
    if (!self.childViewControllers.count) {
        viewController.view.frame = self.contentScrollView.bounds;
        [self.contentScrollView addSubview:viewController.view];
    }
    [self.childViewControllers addObject:viewController];
}

- (void)updateTitles:(NSArray *)titles
{
    for (int i=0; i<MIN(titles.count, self.titles.count); i++) {
        MenuLabel *label = [self.titleScrollView viewWithTag:1000+i];
        label.text = titles[i];
    }
}

#pragma mark - private
- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    if ([self.needScrollToTopPage isKindOfClass:[UITableViewController class]]) {
        self.needScrollToTopPage.tableView.scrollsToTop = NO;
    }
    self.needScrollToTopPage = self.childViewControllers[index];
    if ([self.needScrollToTopPage isKindOfClass:[UITableViewController class]]) {
        self.needScrollToTopPage.tableView.scrollsToTop = YES;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    self.currentIndex = index;
    // 滚动标题栏
    MenuLabel *titleLable = (MenuLabel *)[self.titleScrollView viewWithTag:1000+index];
    CGFloat offsetx = titleLable.center.x - self.titleScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    if (offsetx < 0 || offsetMax<0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetx, self.titleScrollView.contentOffset.y);
    [self.titleScrollView setContentOffset:offset animated:YES];
    
    for (UIView *view in self.titleScrollView.subviews) {
        if ([view isKindOfClass:[MenuLabel class]] && view.tag != 1000+index) {
            ((MenuLabel *)view).scale = 0.0;
        }
    }
    [self setScrollToTopWithTableViewIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(menuCtrl:itemSelected:)]) {
        [self.delegate menuCtrl:self itemSelected:self.currentIndex];
    }
    
    UIViewController *tableVC = self.childViewControllers[index];
    if (tableVC.view.superview) return;
    
    tableVC.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:tableVC.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    MenuLabel *labelLeft = [self.titleScrollView viewWithTag:1000+leftIndex];
    if (!labelLeft) {
        return;
    }
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.titles.count) {
        MenuLabel *labelRight = [self.titleScrollView viewWithTag:1000+rightIndex];
        labelRight.scale = scaleRight;
        CGFloat width = scaleLeft*labelLeft.width+scaleRight*labelRight.width-20;
        CGFloat left = labelLeft.left+10+labelLeft.width*(1-scaleLeft);
        if (left+width>labelRight.right-10) {
            left = labelRight.right-10-width;
        }
        self.menuIndicator.frame = CGRectMake(left, 38, width>0?width:0, 2);
    }
}

#pragma mark - actions
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    MenuLabel *titlelable = (MenuLabel *)recognizer.view;
    CGFloat offsetX = (titlelable.tag-1000) * self.contentScrollView.frame.size.width;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.contentScrollView setContentOffset:offset animated:YES];
    [self setScrollToTopWithTableViewIndex:titlelable.tag-1000];
}

#pragma mark - getters and setters
- (void)setTitles:(NSArray *)titles
{
    _titles = [titles copy];
    for (UIView *view in self.titleScrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat totalWidth = 0;
    for (int i=0; i<titles.count; i++) {
        CGFloat lblW = 0;
        if (self.titleWidthEqual) {
            lblW = kScreenWidth/titles.count;
            if (i==0) {
                self.menuIndicator.frame = CGRectMake(0, 38, lblW, 2);
            }
        } else {
            CGSize titleSize = [QMUtil getSizeWithText:titles[i] font:XiHeiFont(16)];
            lblW = titleSize.width+20;
            if (i==0) {
                self.menuIndicator.frame = CGRectMake(10, 38, titleSize.width, 2);
            }
        }
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = totalWidth;
        totalWidth = lblX + lblW;
        MenuLabel *label = [[MenuLabel alloc]init];
        label.text = titles[i];
        label.frame = CGRectMake(lblX, lblY, lblW, lblH);
        label.font = XiHeiFont(16);
        label.textAlignment = NSTextAlignmentCenter;
        [self.titleScrollView addSubview:label];
        label.tag = 1000+i;
        label.userInteractionEnabled = YES;
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    self.titleScrollView.contentSize = CGSizeMake(totalWidth, 0);
    self.contentScrollView.contentSize = CGSizeMake(titles.count*kScreenWidth, self.contentScrollView.height);
    [self scrollViewDidScroll:self.contentScrollView];
}

- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] init];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.scrollsToTop = NO;
        _titleScrollView.backgroundColor = [UIColor clearColor];
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.scrollsToTop = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.backgroundColor = [UIColor clearColor];
    }
    return _contentScrollView;
}

- (NSMutableArray *)childViewControllers
{
    if (!_childViewControllers) {
        _childViewControllers = [NSMutableArray array];
    }
    return _childViewControllers;
}

- (UIView *)menuIndicator
{
    if (!_menuIndicator) {
        _menuIndicator = [[UIView alloc] init];
        _menuIndicator.backgroundColor = kBlueColor;
    }
    return _menuIndicator;
}

@end

@implementation MenuLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = XiHeiFont(16);
        
        self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
//    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];
    
    CGFloat minScale = 0.9;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end

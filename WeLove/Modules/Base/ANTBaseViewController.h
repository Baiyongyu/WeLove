//
//  ANZBaseViewController.h
//  anz
//
//  Created by KevinCao on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTBaseViewController : UIViewController

@property(nonatomic,strong)UIView *navBar;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIScrollView* contentView;

- (void)leftBtnAction;
- (void)rightBtnAction;
- (void)loadSubViews;
- (void)layoutConstraints;
- (void)loadData;
/**
 *  处理键盘弹出时遮住输入框
 */
- (void)handleKeyboardShowEvent;
- (void)handleKeyboardShowEventForScrollView:(UIScrollView *)scrollView;

@end

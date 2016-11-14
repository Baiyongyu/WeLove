//
//  ANZMenuControl.h
//  anz
//
//  Created by KevinCao on 16/7/19.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QMMenuControl;
@protocol QMMenuControlDelegate <NSObject>
- (void)menuCtrl:(QMMenuControl*)menuCtrl itemSelected:(NSInteger)selectedIndex;
@end

@interface QMMenuControl : UIView
@property(nonatomic,copy)NSArray *titles;
@property(nonatomic,retain,readonly)NSMutableArray *childViewControllers;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,weak)id<QMMenuControlDelegate>delegate;
@property(nonatomic,assign)BOOL titleWidthEqual;
- (void)addChildViewController:(UIViewController *)viewController;
- (void)updateTitles:(NSArray *)titles;
@end

@interface MenuLabel : UILabel
@property (nonatomic,assign)CGFloat scale;
@end

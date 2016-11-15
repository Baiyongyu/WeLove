//
//  HeadLineView.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.

#import <UIKit/UIKit.h>

@protocol headLineDelegate <NSObject>

@optional
- (void)refreshHeadLine:(NSInteger)currentIndex;
@end

@interface HeadLineView : UIView
@property(nonatomic,assign) NSInteger CurrentIndex;
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,assign) id<headLineDelegate>delegate;
@end

//
//  HeadLineView.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "HeadLineView.h"

@interface HeadLineView()
{
    UIButton *currentSelected;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    //按钮的数据
    NSMutableArray * buttonArray;
}
@end

@implementation HeadLineView

- (instancetype)init {
    if (self = [super init]) {
        buttonArray = [[NSMutableArray alloc] init];
    }
    return self;
}
// 传入currentIndex
- (void)setCurrentIndex:(NSInteger)CurrentIndex {
    _CurrentIndex = CurrentIndex; // 改变currentIndex
    [self shuaxinJiemian:_CurrentIndex];
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}
// 刷新界面
- (void)shuaxinJiemian:(NSInteger)index {
    if (buttonArray.count > 0) { // 防止没创建前为空
        for (UIButton *labelView in buttonArray) {
            if (labelView.tag == index) {
                if (labelView.tag == 0) {
                    // 红线
                    label1.backgroundColor = kNavColor;
                }else if (labelView.tag == 1) {
                    label2.backgroundColor = kNavColor;
                }else {
                    label3.backgroundColor = kNavColor;
                }
                currentSelected = labelView;
            }else {
                if (labelView.tag == 0) {
                    // 默认颜色
                    label1.backgroundColor = kDefaultViewBackgroundColor;
                }else if (labelView.tag == 1){
                    label2.backgroundColor = kDefaultViewBackgroundColor;
                }else {
                    label3.backgroundColor = kDefaultViewBackgroundColor;
                }
            }
        }
    }
}
//按钮点击 传入代理
- (void)buttonClick:(UIButton*)button {
    NSInteger viewTag = [button tag];
    if ([button isEqual:currentSelected]) {
        return;
    }
    _CurrentIndex = viewTag;
    [self shuaxinJiemian:_CurrentIndex];
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}

// 传入顶部的title
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    UIButton *btn = NULL;
    CGFloat width = kScreenWidth/_titleArray.count;
    for (int i = 0; i < _titleArray.count; i++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 0, width, 48);
        btn.tag = i;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = XiHeiFont(17.0f);
        [btn setTitleColor:kNavColor forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setUserInteractionEnabled:YES];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:btn];
        [self addSubview:btn];
        
        if (i == 0) {
            currentSelected = btn;
            // 红线
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45.5, kScreenWidth/3, 2.5)];
            label1.backgroundColor = kNavColor;
            [self addSubview:label1];
        }else if(i == 1) {
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(width, 45.5, kScreenWidth/3, 2.5)];
            label2.backgroundColor = kDefaultViewBackgroundColor;
            [self addSubview:label2];
        }else {
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(width * 2, 45.5, kScreenWidth/3, 2.5)];
            label3.backgroundColor = kDefaultViewBackgroundColor;
            [self addSubview:label3];
        }
    }
}
@end

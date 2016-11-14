//
//  ANZButton.h
//  anz
//
//  Created by KevinCao on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMButton : UIButton
@property(nonatomic,assign)BOOL relayout;
@property(nonatomic,assign)CGRect imageViewFrame;
@property(nonatomic,assign)CGRect titleLabelFrame;
@property(nonatomic,assign)int msgCount;
@property(nonatomic,assign)CGFloat msgCountOffset;
@end

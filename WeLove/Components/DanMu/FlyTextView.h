//
//  FlyTextView.h
//  BulletScreen
//
//  Created by 宇玄丶 on 2016/12/5.
//  Copyright © 2016年 宇玄丶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlyTextView : UILabel

- (instancetype)initWithY:(CGFloat)y AndText:(NSString*)text AndWordSize:(CGFloat)wordSize;

@end

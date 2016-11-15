//
//  DayTimeOneCelll.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayTimeCell : UITableViewCell
+ (UINib *)nib;
- (void)refreshUIWithImageArray:(NSArray *)array time:(NSString *)time;
@end

//
//  TimeTwoCell.h
//  60730-TimeLine
//
//  Created by iOS_Chris on 16/7/30.
//  Copyright © 2016年 shu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTwoCell : UITableViewCell
+(UINib *)nib;
- (void)refreshUIWithImageArray:(NSArray *)array;
@end

//
//  HappinessTimeTableViewController.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HappinessTimeTableViewController : BaseTableViewController
@end

@interface HappinessTimeCell : UITableViewCell
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,retain)HappyTimeModel *activityData;
@end

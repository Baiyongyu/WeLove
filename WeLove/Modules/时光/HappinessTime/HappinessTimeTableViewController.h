//
//  FarmActivityTableViewController.h
//  inongtian
//
//  Created by KevinCao on 2016/10/24.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "ANTBaseTableViewController.h"

@interface HappinessTimeTableViewController : ANTBaseTableViewController
@end

@interface HappinessTimeCell : UITableViewCell
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,retain)FarmActivityModel *activityData;
@end

//
//  HomeFirstViewCell.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/12/13.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BtnClickActionBlock)();
typedef void (^ShareBtnActionBlock)();
@interface HomeSecondViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *oursName;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic, copy) BtnClickActionBlock btnClickActionBlock;
@property (nonatomic, copy) ShareBtnActionBlock shareBtnActionBlock;

- (IBAction)btnClickAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;

+ (instancetype)homeSecondCellWithTableView:(UITableView *)tableView;

@end

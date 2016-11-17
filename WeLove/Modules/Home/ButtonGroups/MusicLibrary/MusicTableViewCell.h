//
//  MusicTableViewCell.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/16.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicModel.h"

@interface MusicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UILabel *songName;

@property(nonatomic,strong) MusicModel *musicModel;

@end

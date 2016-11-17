//
//  MusicTableViewCell.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/16.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell

//- (void)setMusicModel:(MusicModel *)musicModel {
//    _musicModel = musicModel;
//    [self.imgView setImageWithURLString:musicModel.icon placeholderImage:nil];
//    self.singerName.text = [NSString stringWithFormat:@"%@", musicModel.singer];
//    self.songName.text = [NSString stringWithFormat:@"%@", musicModel.name];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

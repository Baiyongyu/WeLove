//
//  ComponentsModel.m
//  anz
//
//  Created by KevinCao on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ComponentsModel.h"

@implementation ANTLeftMenuItemModel

- (id)copyWithZone:(NSZone *)zone
{
    ANTLeftMenuItemModel *newItem = [[ANTLeftMenuItemModel allocWithZone:zone] init];
    newItem.icon = self.icon;
    newItem.title = self.title;
    return newItem;
}

@end

@implementation QMImageModel

- (id)copyWithZone:(NSZone *)zone
{
    QMImageModel *newItem = [[QMImageModel allocWithZone:zone] init];
    newItem.imageId = self.imageId;
    newItem.imageUrl = self.imageUrl;
    newItem.imageTitle = self.imageTitle;
    newItem.image = self.image;
    newItem.isVideo = self.isVideo;
    newItem.videoUrl = self.videoUrl;
    newItem.videoLocalPath = self.videoLocalPath;
    return newItem;
}

@end

@implementation ANTCellModel

- (id)copyWithZone:(NSZone *)zone
{
    ANTCellModel *newItem = [[ANTCellModel allocWithZone:zone] init];
    newItem.cellIcon = self.cellIcon;
    newItem.cellTitle = self.cellTitle;
    newItem.cellContent = self.cellContent;
    newItem.select = self.select;
    newItem.indexPath = self.indexPath;
    return newItem;
}

@end

@implementation ANZKeyValueModel

- (id)copyWithZone:(NSZone *)zone
{
    ANZKeyValueModel *newItem = [[ANZKeyValueModel allocWithZone:zone] init];
    newItem.key = self.key;
    newItem.value = self.value;
    return newItem;
}

@end

//
//  ComponentsModel.h
//  anz
//
//  Created by KevinCao on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  侧滑菜单项Model
 */
@interface ANTLeftMenuItemModel : NSObject
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@end

/**
 *  图片Model
 */
@interface QMImageModel : NSObject
//图片id
@property(nonatomic,copy)NSString *imageId;
//图片链接
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *imageUrl2;
@property(nonatomic,copy)NSString *imageUrl3;
//图片标题
@property(nonatomic,copy)NSString *imageTitle;
//图片
@property(nonatomic,retain)UIImage *image;
//是否是视频
@property(nonatomic,assign)BOOL isVideo;
//视频链接
@property(nonatomic,copy)NSString *videoUrl;
//视频本地路径
@property(nonatomic,copy)NSString *videoLocalPath;
@end

/**
 *  cell Model
 */
@interface ANTCellModel : NSObject
//cell图标
@property(nonatomic,copy)NSString *cellIcon;
//cell标题
@property(nonatomic,copy)NSString *cellTitle;
//cell内容
@property(nonatomic,copy)NSString *cellContent;
//是否选中
@property(nonatomic,assign)BOOL select;
//indexPath
@property(nonatomic,copy)NSIndexPath *indexPath;
@end

/**
 *  键值对Model
 */
@interface ANZKeyValueModel : NSObject
//key
@property(nonatomic,copy)NSString *key;
//value
@property(nonatomic,copy)NSString *value;
@end

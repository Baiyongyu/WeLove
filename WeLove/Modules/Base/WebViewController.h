//
//  BaseWebViewController.h
//  WeLove
//
//  Created by 宇玄丶 on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController <UIWebViewDelegate>
//网页链接
@property(nonatomic,copy)NSString *urlStr;
//本地文件路径
@property(nonatomic,copy)NSString *filePath;
//html内容
@property(nonatomic,copy)NSString *content;
@end

//
//  ANZBaseWebViewController.h
//  anz
//
//  Created by KevinCao on 16/7/1.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "ANTBaseViewController.h"

@interface QMWebViewController : ANTBaseViewController <UIWebViewDelegate>
//网页链接
@property(nonatomic,copy)NSString *urlStr;
//本地文件路径
@property(nonatomic,copy)NSString *filePath;
//html内容
@property(nonatomic,copy)NSString *content;
@end

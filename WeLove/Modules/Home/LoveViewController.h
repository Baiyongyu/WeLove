//
//  LoveViewController.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoveViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgShadowView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
- (IBAction)buttonAction:(id)sender;
@end

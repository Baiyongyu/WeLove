//
//  AlbumPhotosViewController.m
//  inongtian
//
//  Created by 宇玄丶 on 2016/11/8.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "AlbumPhotosViewController.h"
#import "ComAlbumPhoto.h"

#import "FFBarrageManager.h"
#import "FFBarrageView.h" // 弹幕

@interface AlbumPhotosViewController ()
@property(nonatomic, strong) NSMutableArray *photos;
/** 弹幕 */
@property(nonatomic, strong) FFBarrageManager *manager;
@end

@implementation AlbumPhotosViewController

- (void)loadSubViews
{
    [super loadSubViews];
    self.titleLabel.text = @"流式相册";
    self.leftBtn.hidden = NO;
    
    // 弹幕效果
    _manager = [[FFBarrageManager alloc] initWithComments:@[@"2016.1026.5.20，我们在一起~~~~~~~~~~~~~~", @"小v，我爱你~~~~~~~~~~~~~~~~~~", @"亲爱的，你说我为什么那么喜欢你的名字呢？~~~~~~~~~~~~~~~~~~~~~~~~",
                                                            @"老婆，老公爱你~~~~~~~~~~~~~~", @"亲爱的的，么么哒~~~~~~~~~~~~~~~~~~", @"我们会一直幸福下去的~~~~~~~~~~~~~~~~~~",
                                                            @"亲爱的，要等我来娶你哦~~~~~~~~~~~~~", @"宇哥爱小v~~~~~~~~~~~~~~~~~~~~~~~~", @"爱上你从那天起，甜蜜的很轻易~~~~~~~~~~~"]];
    WS(weakSelf);
    _manager.trajectoryCount = 5;
    _manager.generateViewBlock = ^(FFBarrageView *barrageView){
        barrageView.frame = CGRectMake(kScreenWidth, barrageView.trajectory * 40 + 165, barrageView.frame.size.width, 30);
        [weakSelf.view addSubview:barrageView];
        
        [barrageView startAnimation];
    };
    [_manager start];
    
    
    
    self.photos = [[NSMutableArray alloc] init];
    NSMutableArray *photoPaths = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSLog(@"path = %@", path);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileNames = [fm contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *fileName in fileNames ) {
        if ([fileName hasSuffix:@"jpeg"] || [fileName hasSuffix:@"JPG"]) {
            NSString *photoPath = [path stringByAppendingPathComponent:fileName];
            [photoPaths addObject:photoPath];
        }
    }
    
    // 添加图片到界面中
    if (photoPaths) {
        for (int i = 0; i < 18; i++) {
            //减去 一个图片的长 和 宽 是用于 随机出的图片有足够的空间去显示 自己自身
            float X = arc4random()%((int)self.view.bounds.size.width - IMAGEWIDTH);
            float Y = arc4random()%((int)self.view.bounds.size.height - IMAGEHEIGHT);
            float W = IMAGEWIDTH;
            float H = IMAGEHEIGHT;
            
            ComAlbumPhoto *photo = [[ComAlbumPhoto alloc] initWithFrame:CGRectMake(X, Y, W, H)];
            
            [photo updateImage:[UIImage imageWithContentsOfFile:photoPaths[i]]];
            [self.view addSubview:photo];
            
            // 写入图片的速度和透明度;
            float alpha = i*1.0/10 + 0.2;
            [photo setImageAlphaAndSpeedAndSize:alpha];
            [self.photos addObject:photo];
        }
    }
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:doubleTap];
}

- (void)doubleTap {
    NSLog(@"DoubleTap...........");
    
    for (ComAlbumPhoto *photo in self.photos) {
        if (photo.state == ComPhotoStateDraw || photo.state == ComPhotoStateBig) {
            return;
        }
    }
    
    float W = self.view.bounds.size.width / 3;
    float H = self.view.bounds.size.height / 3;
    
    __block int x = 0;
    __block int y = 0;
    
    
    [UIView animateWithDuration:2 animations:^{
        for (int i = 0; i < self.photos.count; i++) {
            ComAlbumPhoto *photo = [self.photos objectAtIndex:i];
            
            if (photo.state == ComPhotoStateNormal) {
                //old的参数 用来记录之前的数据信息
                photo.oldAlpha = photo.alpha;
                photo.oldFrame = photo.frame;
                photo.oldSpeed = photo.speed;
                photo.alpha = 1;
                photo.frame = CGRectMake(x, y, W, H);
                i%4 != 3 ? (x += W) : (x = 0,y += H);
                photo.imageView.frame = photo.bounds;
                photo.drawView.frame = photo.bounds;
                photo.speed = 0;
                photo.state = ComPhotoStateTogether;
            } else if (photo.state == ComPhotoStateTogether || photo.state == ComPhotoStateTogetherBig) {
                photo.alpha = photo.oldAlpha;
                photo.frame = photo.oldFrame;
                photo.speed = photo.oldSpeed;
                photo.imageView.frame = photo.bounds;
                photo.drawView.frame = photo.bounds;
                photo.state = ComPhotoStateNormal;
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

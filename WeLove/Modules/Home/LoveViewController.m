//
//  LoveViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "LoveViewController.h"
#import "HomeWeatherView.h"         // 天气
#import "AnimaViewController.h"     // 动画
#import "ComAnimationLayer.h"
#import "MemoryDayViewController.h" // 纪念日
#import "WishViewController.h"      // 心愿
@interface LoveViewController ()
{
    UIView *bgViewContainer;
    UIButton *_centerButton;
}
//天气
@property(nonatomic,strong)HomeWeatherView *weatherView;
@end

@implementation LoveViewController

#pragma mark - life style
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!locationManager.userLocation.location) {
        [locationManager startLocation];
    }
    [self.weatherView updateDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 天气
    [self.bgShadowView addSubview:self.weatherView];
    // 设置一排固定间距自动宽度子view
    [self setupAutoWidthViewsWithCount:4 margin:10];
}

#pragma mark - 设置一排固定间距自动宽度子view
- (void)setupAutoWidthViewsWithCount:(NSInteger)count margin:(CGFloat)margin {
    
    bgViewContainer = [UIView new];
    bgViewContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgViewContainer];
    
    NSMutableArray *temp = [NSMutableArray new];
    
    NSArray *titleArray = @[@"纪念日", @"心愿球", @"嘻嘻嘻", @"哈哈哈"];
    NSArray *imgArray = @[@"indexPageIconAnni_26x26_", @"indexPageIconWish_26x26_", @"indexPageIconClock_26x26_", @"indexPageIconPunch_26x26_"];
    for (int i = 0; i < count; i++) {
        _centerButton = [UIButton new];
        [_centerButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [_centerButton setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        [_centerButton setBackgroundImage:[UIImage imageNamed:@"indexPageBgSquare_89x74_"] forState:UIControlStateNormal];
        _centerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _centerButton.titleLabel.font = XiHeiFont(10);
        _centerButton.tag = i + 1;
        [_centerButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_centerButton setTitleColor:kLightGrayColor forState:UIControlStateNormal];
        _centerButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [bgViewContainer addSubview:_centerButton];
        
        _centerButton.sd_layout.autoHeightRatio(0.8);
        [temp addObject:_centerButton];
        
        _centerButton.sd_layout
        .centerXEqualToView(bgViewContainer)
        .topSpaceToView(bgViewContainer, 5)
        .widthRatioToView(bgViewContainer, 0.5)
        .heightIs(60);
        
        // 设置button的图片的约束
        _centerButton.imageView.sd_layout
        .widthRatioToView(_centerButton, 0.8)
        .topSpaceToView(_centerButton, 10)
        .centerXEqualToView(_centerButton)
        .heightRatioToView(_centerButton, 0.4);
        
        // 设置button的label的约束
        _centerButton.titleLabel.sd_layout
        .topSpaceToView(_centerButton.imageView, 5)
        .leftEqualToView(_centerButton.imageView)
        .rightEqualToView(_centerButton.imageView)
        .bottomSpaceToView(_centerButton, 10);
    }
    
    bgViewContainer.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 69);
    
    // 此步设置之后_autoWidthViewsContainer的高度可以根据子view自适应
    [bgViewContainer setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:margin horizontalMargin:margin verticalEdgeInset:5 horizontalEdgeInset:10];
}

#pragma mark - 首页下方按钮组事件
- (void)chooseAction:(UIButton *)btn {
    if (btn.tag == 1) {
        MemoryDayViewController *memoryVC = [[MemoryDayViewController alloc] init];
        [kRootNavigation pushViewController:memoryVC animated:YES];
    } else if (btn.tag == 2) {
        WishViewController *wishVC = [[WishViewController alloc] init];
        [kRootNavigation pushViewController:wishVC animated:YES];
    }
}

#pragma mark - 点击播放按钮
- (IBAction)buttonAction:(id)sender {
    
    self.playBtn.hidden = YES;
    
    // 显示雪花
    [self snow];
    
    [self SetupEmitter];
    
    for (id layer in self.view.layer.sublayers) {
        if([layer isKindOfClass:[ComAnimationLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }

    [ComAnimationLayer createAnimationLayerWithString:@"小v，我爱你" andRect: CGRectMake(0, CGRectGetMaxY(_weatherView.frame) + 50, kScreenWidth, kScreenWidth) andView:self.view andFont:[UIFont boldSystemFontOfSize:40] andStrokeColor:kNavColor];
}

#pragma mark - 开始动画
- (void)SetupEmitter {
    // Cells spawn in the bottom, moving up
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize	= CGSizeMake(1, 0.0);
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    //fireworksEmitter.seed = 500;//(arc4random()%100)+300;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 6.0;
    rocket.emissionRange	= 0.12 * M_PI;  // some variation in angle
    rocket.velocity			= 500;
    rocket.velocityRange	= 150;
    rocket.yAcceleration	= 0;
    rocket.lifetime			= 2.02;	// we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents			= (id) [[UIImage imageNamed:@"ball"] CGImage];
    rocket.scale			= 0.2;
    //    rocket.color			= [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    rocket.greenRange		= 1.0;		// different colors
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    
    rocket.spinRange		= M_PI;		// slow spin
    
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=-1.5;		// shifting
    burst.blueSpeed			=+1.5;		// shifting
    burst.greenSpeed		=+1.0;		// shifting
    burst.lifetime			= 0.35;
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 666;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;	// 360 deg
    spark.yAcceleration		= 75;		// gravity
    spark.lifetime			= 3;
    
    spark.contents			= (id) [[UIImage imageNamed:@"fire"] CGImage];
    spark.scale		        =0.5;
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=-0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=-0.1;
    spark.alphaSpeed		=-0.5;
    spark.spin				= 2* M_PI;
    spark.spinRange			= 2* M_PI;
    
    // putting it together
    fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells				= [NSArray arrayWithObject:burst];
    burst.emitterCells				= [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:fireworksEmitter];
}

//纵向移动
- (CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y {
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    animation.toValue = y;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}

- (CAAnimation *)SetupScaleAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleAnimation.duration = 3.0;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:40.0];
    //scaleAnimation.repeatCount = MAXFLOAT;
    //scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    
    return scaleAnimation;
}

- (CAAnimation *)SetupGroupAnimation {
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 3.0;
    groupAnimation.animations = @[[self moveY:3.0f Y:[NSNumber numberWithFloat:-300.0f]]];
    //groupAnimation.autoreverses = YES;
    //groupAnimation.repeatCount = MAXFLOAT;
    return groupAnimation;
}

#pragma mark - 创建雪花
- (void)snow {
    // 雪花／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
    
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);
    snowEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);;
    
    // Spawn points for the flakes are within on the outline of the line
    snowEmitter.emitterMode		= kCAEmitterLayerOutline;
    snowEmitter.emitterShape	= kCAEmitterLayerLine;
    
    // Configure the snowflake emitter cell
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    
    //    随机颗粒的大小
    snowflake.scale = 0.2;
    snowflake.scaleRange = 0.5;
    
    //    缩放比列速度
    //        snowflake.scaleSpeed = 0.1;
    
    //    粒子参数的速度乘数因子；
    snowflake.birthRate		= 20.0;
    
    //生命周期
    snowflake.lifetime		= 60.0;
    
    //    粒子速度
    snowflake.velocity		= 20;				// falling down slowly
    snowflake.velocityRange = 10;
    //    粒子y方向的加速度分量
    snowflake.yAcceleration = 2;
    
    //    周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;		// some variation in angle
    //    自动旋转
    snowflake.spinRange		= 0.25 * M_PI;		// slow spin
    
    snowflake.contents		= (id) [[UIImage imageNamed:@"fire"] CGImage];
    snowflake.color			= [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:1.000] CGColor];
    
    // Make the flakes seem inset in the background
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    // Add everything to our backing layer below the UIContol defined in the storyboard
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.view.layer addSublayer:snowEmitter];
    
    //    [self.view.layer insertSublayer:snowEmitter atIndex:0];
    //// 雪花／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
    //// 雪花／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (HomeWeatherView *)weatherView {
    if (!_weatherView) {
        _weatherView = [[HomeWeatherView alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, 170)];
    }
    return _weatherView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

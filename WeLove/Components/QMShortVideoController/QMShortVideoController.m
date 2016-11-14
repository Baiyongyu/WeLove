//
//  QMShortVideoController.m
//  inongtian
//
//  Created by KevinCao on 2016/10/28.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "QMShortVideoController.h"
#import "PKShortVideo.h"
#import "PKPlayerView.h"
#import "NSTimer+QM.h"
#import "CacheManager.h"

@interface QMShortVideoController () <PKShortVideoRecorderDelegate>
//录制按钮外圈
@property(nonatomic,strong)UIImageView *roundImageView;
//录制按钮
@property(nonatomic,strong)UIButton *recordBtn;
//录制界面背景
@property(nonatomic,strong)UIView *recordView;
@property(nonatomic,strong)PKShortVideoRecorder *recorder;
@property(nonatomic, strong)PKPlayerView *playerView;
@property (strong, nonatomic) NSTimer *recordTimer;
@property(nonatomic,assign)NSInteger recordSeconds;
@property (nonatomic, assign) CFAbsoluteTime beginRecordTime;
@property (nonatomic, strong) NSString *outputFileName;
@property (nonatomic, strong) NSString *outputFilePath;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIButton *finishTipBtn;

@end

@implementation QMShortVideoController

- (void)loadSubViews
{
    [super loadSubViews];
    self.videoMaximumDuration = 10;
    self.videoMinimumDuration = 1;
    
    self.leftBtn.hidden = NO;
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    [self.leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.rightBtn.hidden = NO;
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.navBar.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.recordView];
    [self.contentView addSubview:self.roundImageView];
    [self.contentView addSubview:self.recordBtn];
    [self.contentView addSubview:self.finishTipBtn];
    self.finishTipBtn.hidden = YES;
    
    //视频路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    self.outputFileName = [[QMUtil formatter:@"yyyyMMddHHmmss" fromeDate:[NSDate date]] stringByAppendingPathExtension:@"mp4"];
    NSString *path = [paths[0] stringByAppendingPathComponent:self.outputFileName];
    //创建视频录制对象
    self.recorder = [[PKShortVideoRecorder alloc] initWithOutputFilePath:path outputSize:CGSizeMake(480, 640)];
    //通过代理回调
    self.recorder.delegate = self;
    //录制时需要获取预览显示的layer，根据情况设置layer属性，显示在自定义的界面上
    AVCaptureVideoPreviewLayer *previewLayer = [self.recorder previewLayer];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = CGRectMake(0, 64, kScreenWidth, kScreenWidth*4/3);
    [self.view.layer insertSublayer:previewLayer above:self.recordView.layer];
}

- (void)layoutConstraints
{
    WS(weakSelf);
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(64);
        make.height.mas_equalTo(weakSelf.recordView.mas_width).multipliedBy(4.0/3);
    }];
    
    [self.roundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-20);
        make.width.height.mas_equalTo(67);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.roundImageView);
        make.width.height.mas_equalTo(50);
    }];
    self.recordBtn.layer.cornerRadius = 25;
    
    [self.finishTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.roundImageView);
        make.height.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
}

- (void)loadData
{
    [self.recorder startRunning];
}

- (void)dealloc
{
    [self.recorder stopRecording];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ([self.recordTimer isValid]) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
}

- (void)updateTitleLabel:(NSInteger)seconds
{
    self.titleLabel.text = [NSString stringWithFormat:@"00:%02ld",seconds%60];
}

- (void)endRecordingWithPath:(NSString *)path failture:(BOOL)failture {
    self.recordBtn.selected = NO;
    
    if (failture) {
        [MBProgressHUD showTip:@"生成视频失败"];
    } else {
        [MBProgressHUD showTip:[NSString stringWithFormat:@"视频长度少于%@秒钟",@(self.videoMinimumDuration)]];
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)finishRecord
{
    self.roundImageView.hidden = YES;
    self.recordBtn.hidden = YES;
    self.finishTipBtn.hidden = NO;
    self.image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:self.outputFilePath]];
    if (!_playerView) {
        [[PKPlayerManager sharedManager] creatMessagePlayer];
        //实例化播放view
        _playerView = [[PKPlayerView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth*4/3) videoPath:self.outputFilePath previewImage:self.image];
    }
    [self.view.layer addSublayer:self.playerView.layer];
    [self.playerView play];
}


#pragma mark - PKShortVideoRecorderDelegate

- (void)recorderDidBeginRecording:(PKShortVideoRecorder *)recorder
{
    //录制长度限制到时间停止
    WS(weakSelf);
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        if (weakSelf.recordSeconds<=0) {
            [weakSelf.recorder stopRecording];
            return;
        }
        weakSelf.recordSeconds--;
        [weakSelf updateTitleLabel:self.recordSeconds];
    } repeats:YES];
}

- (void)recorderDidEndRecording:(PKShortVideoRecorder *)recorder
{
    
}

- (void)recorder:(PKShortVideoRecorder *)recorder didFinishRecordingToOutputFilePath:(NSString *)outputFilePath error:(NSError *)error
{
    //解除自动锁屏限制
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ([self.recordTimer isValid]) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
    //录制成功返回路径，录制失败返回错误对象
    if (error) {
        NSLog(@"视频拍摄失败: %@", error );
        [self endRecordingWithPath:outputFilePath failture:YES];
    } else {
        //当前时间
        CFAbsoluteTime nowTime = CACurrentMediaTime();
        if (self.beginRecordTime != 0 && nowTime - self.beginRecordTime < self.videoMinimumDuration) {
            [self endRecordingWithPath:outputFilePath failture:NO];
        } else {
            self.outputFilePath = outputFilePath;
            [self.recorder stopRunning];
            [self finishRecord];
        }
    }
}

#pragma mark - actions
-(void)recordBtnClick:(UIButton *)sender
{
    if (!sender.selected) {
        //静止自动锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        self.beginRecordTime = CACurrentMediaTime();
        [self.recorder startRecording];
        sender.selected = YES;
    } else {
        [self.recorder stopRecording];
    }
}

-(void)leftBtnAction
{
    [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnAction
{
    [self rightBtnAction];
}

-(void)finishAction
{
    if (self.outputFilePath.length) {
        [MBProgressHUD showMessage:@"视频上传中" toView:self.view];
    }
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(BaseAPIManager *)manager
{
    return @{@"file":self.outputFilePath};
}

- (void (^)(id <AFMultipartFormData> formData))uploadBlock:(BaseAPIManager *)manager
{
    
    return nil;
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager
{
    [MBProgressHUD showTip:@"视频上传成功"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager
{
    [MBProgressHUD showTip:manager.errorMessage];
}

#pragma mark - getters and setters
-(void)setVideoMaximumDuration:(NSTimeInterval)videoMaximumDuration
{
    _videoMaximumDuration = videoMaximumDuration;
    self.recordSeconds = _videoMaximumDuration;
    [self updateTitleLabel:self.recordSeconds];
}

-(UIImageView *)roundImageView
{
    if (!_roundImageView) {
        _roundImageView = [[UIImageView alloc] init];
        _roundImageView.image = [UIImage imageNamed:@"ic_video_record_round"];
    }
    return _roundImageView;
}

-(UIButton *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"ic_video_record_normal"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"ic_video_record_select"] forState:UIControlStateSelected];
        [_recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn.layer.masksToBounds = YES;
    }
    return _recordBtn;
}

-(UIView *)recordView
{
    if (!_recordView) {
        _recordView = [[UIView alloc] init];
        _recordView.backgroundColor = [UIColor whiteColor];
    }
    return _recordView;
}

-(UIButton *)finishTipBtn
{
    if (!_finishTipBtn) {
        _finishTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishTipBtn.titleLabel.font = XiHeiFont(16);
        [_finishTipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishTipBtn setTitle:@"点击确定上传" forState:UIControlStateNormal];
        [_finishTipBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishTipBtn;
}



@end

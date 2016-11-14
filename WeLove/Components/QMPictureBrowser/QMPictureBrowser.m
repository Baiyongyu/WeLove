//
//  QMPictureBrowser.m
//  inongtian
//
//  Created by KevinCao on 2016/10/25.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "QMPictureBrowser.h"
#import "PictureFullScreenBrowser.h"
#import "PKFullScreenPlayerViewController.h"
#import "UIImage+PKShortVideoPlayer.h"
#import "CacheManager.h"

static NSString * const collectionCell = @"photoCell";

@interface QMPictureBrowser () <UICollectionViewDelegate,UICollectionViewDataSource,PictureFullScreenBrowserDelegate>
@property(nonatomic,strong)UICollectionView *pictureCollectionView;
@end

@implementation QMPictureBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.columeCount = 3;
    }
    return self;
}

-(void)initUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 1;
    self.pictureCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.pictureCollectionView.dataSource = self;
    self.pictureCollectionView.delegate = self;
    self.pictureCollectionView.bounces = NO;
    self.pictureCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pictureCollectionView];
    
    [self.pictureCollectionView registerClass:[QMPictureCell class] forCellWithReuseIdentifier:collectionCell];
}

- (void)updateProgress:(CGFloat)progress indexFlag:(NSInteger)indexFlag indexPath:(NSIndexPath *)indexPath
{
    [[CacheManager sharedCacheManager].cache setObject:@(progress) forKey:[NSString stringWithFormat:@"%ld,%ld",indexFlag,indexPath.row]];
    QMPictureCell *cell = (QMPictureCell *)[self.pictureCollectionView cellForItemAtIndexPath:indexPath];
    if (cell && cell.indexFlag==indexFlag && [self.pictureCollectionView.visibleCells containsObject:cell]) {
        cell.progress = progress;
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pictureArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    cell.imageData = self.pictureArray[indexPath.row];
    cell.indexFlag = self.indexFlag;
    cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.indexFlag];
    CGFloat progress = [[[CacheManager sharedCacheManager].cache objectForKey:[NSString stringWithFormat:@"%ld,%ld",self.indexFlag,indexPath.row]] floatValue];
    cell.progress = progress;
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.width-(self.columeCount-1)*10)/self.columeCount, (self.width-(self.columeCount-1)*10)/self.columeCount);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QMImageModel *imageInfo = self.pictureArray[indexPath.row];
    if (imageInfo.isVideo) {
        NSString *videoPath = [[CacheManager sharedCacheManager] inquiryVideoCache:imageInfo.videoUrl];
        if (videoPath && [[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
            UIImage *image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:videoPath]];
            PKFullScreenPlayerViewController *vc = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:videoPath previewImage:image];
            [kRootNavigation presentViewController:vc animated:NO completion:NULL];
        } else {
            WS(weakSelf);
            NSInteger indexFlag = self.indexFlag;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageInfo.videoUrl]];
            NSURLSessionDownloadTask *task = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf updateProgress:downloadProgress.fractionCompleted indexFlag:indexFlag indexPath:indexPath];
                });
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *path = [paths[0] stringByAppendingPathComponent:response.suggestedFilename];
                return [NSURL fileURLWithPath:path];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                if (!error) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString *path = [paths[0] stringByAppendingPathComponent:response.suggestedFilename];
                    [[NSFileManager defaultManager] moveItemAtPath:filePath.path toPath:path error:nil];
                    [[CacheManager sharedCacheManager] savaVideoLocalPath:response.suggestedFilename forUrl:imageInfo.videoUrl];
                } else {
                    [MBProgressHUD showTip:@"视频加载失败"];
                }
            }];
            [task resume];
        }
    } else {
        PictureFullScreenBrowser *browser = [[PictureFullScreenBrowser alloc] init];
        [browser setDelegate:self];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [browser showFormView:cell picturesCount:self.pictureArray.count currentPictureIndex:indexPath.row];
    }
}

#pragma mark - PictureFullScreenBrowserDelegate


/**
 获取对应索引的视图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 视图
 */
- (UIView *)pictureView:(PictureFullScreenBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    UICollectionViewCell *cell = [self.pictureCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell;
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(PictureFullScreenBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    QMImageModel *imageData = self.pictureArray[index];
    return imageData.imageUrl;
}

// 以下两个代理方法必须要实现一个

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片
 */
- (UIImage *)pictureView:(PictureFullScreenBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index
{
    return kDefaultLoadingImage;
}


#pragma mark - getters and setters
-(void)setPictureArray:(NSArray *)pictureArray
{
    _pictureArray = pictureArray;
    CGFloat itemHeight = (self.width-(self.columeCount-1)*10)/self.columeCount;
    CGFloat height = itemHeight;
    if (pictureArray.count%self.columeCount==0) {
        height = (pictureArray.count/self.columeCount-1)*10 + (pictureArray.count/self.columeCount)*itemHeight;
    } else {
        height = pictureArray.count/self.columeCount*10 + (pictureArray.count/self.columeCount+1)*itemHeight;
    }
    self.height = height;
    self.pictureCollectionView.height = self.height;
    [self.pictureCollectionView reloadData];
}

@end

@interface QMPictureCell ()
//视频图标
@property(nonatomic,strong)UIImageView *videoIcon;
@end

@implementation QMPictureCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.picture];
        [self addSubview:self.videoIcon];
        self.videoIcon.hidden = YES;
    }
    return self;
}

#pragma mark - getters and setters
-(void)setImageData:(QMImageModel *)imageData
{
    _imageData = [imageData copy];
    self.videoIcon.hidden = !_imageData.isVideo;
    [self.picture setImageWithURLString:_imageData.imageUrl placeholderImage:kDefaultLoadingImage];
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressView.progress = progress;
    if (_progress<=0 || _progress>=1) {
        self.videoIcon.hidden = !_imageData.isVideo;
        self.progressView.hidden = YES;
    } else {
        self.videoIcon.hidden = YES;
        if (!self.progressView.superview) {
            [self addSubview:self.progressView];
        }
        self.progressView.hidden = NO;
    }
}

-(UIImageView *)picture
{
    if (!_picture) {
        _picture = [[UIImageView alloc] initWithFrame:self.bounds];
        _picture.layer.masksToBounds = YES;
        _picture.contentMode = UIViewContentModeScaleAspectFit;
        _picture.layer.borderWidth = 1;
        _picture.layer.borderColor = [UIColor hexStringToColor:@"#dbdcdc"].CGColor;
    }
    return _picture;
}

-(UIImageView *)videoIcon
{
    if (!_videoIcon) {
        _videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-23)/2.0, (self.height-23)/2.0, 23, 23)];
        _videoIcon.image = [UIImage imageNamed:@"ic_video_preview"];;
        _videoIcon.layer.masksToBounds = YES;
        _videoIcon.contentMode = UIViewContentModeScaleAspectFit;;
    }
    return _videoIcon;
}

-(QMPictureProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[QMPictureProgressView alloc] init];
        _progressView.center = CGPointMake(self.width/2.0, self.height/2.0);
    }
    return _progressView;
}

@end

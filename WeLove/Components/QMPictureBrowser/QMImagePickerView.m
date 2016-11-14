//
//  QMImagePickerView.m
//  inongtian
//
//  Created by KevinCao on 2016/10/28.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "QMImagePickerView.h"
#import "TZImagePickerController.h"
#import "PictureFullScreenBrowser.h"
#import "TZImageManager.h"
#import "QMShortVideoController.h"
#import "UploadPicManager.h"
#import "PKFullScreenPlayerViewController.h"
#import "UIImage+PKShortVideoPlayer.h"
#import "CacheManager.h"

static NSString *collectionViewCellId = @"collectionViewCellId";
static CGFloat imageSize = 80;

@interface QMImagePickerView () <UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,PictureFullScreenBrowserDelegate>
@property(nonatomic, strong) UICollectionView *collectionView; //添加图片,每个cell内有一个imageView
@property(nonatomic, strong) NSMutableArray *cacheImageArray;
@property(nonatomic, assign) NSInteger maxImageCount;
@property(nonatomic,strong)UploadPicManager *uploadPicManager;
@end

@implementation QMImagePickerView

-(instancetype)init
{
    return [self initWithMaxImageCount:3];
}

-(instancetype)initWithMaxImageCount:(NSInteger)maxImageCount
{
    self = [super init];
    if (self) {
        self.maxImageCount = maxImageCount;
        self.backgroundColor = [UIColor clearColor];
        self.imageArray = [NSMutableArray array];
        self.cacheImageArray = [NSMutableArray array];
        [self addSubview:self.collectionView];
        [self layoutConstraints];
    }
    return self;
}

- (void)layoutConstraints
{
    WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArray.count < self.maxImageCount) {
        return self.imageArray.count + 1;
    }
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QMImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    [self addAndSetSubViews:cell indexPath:indexPath];
    return cell;
}

- (void)addAndSetSubViews:(QMImagePickerCell *)cell indexPath:(NSIndexPath *)indexPath{
    //清空子控件,解决重用问题
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    [cell.contentView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    cell.imageView = imageView;
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.row == self.imageArray.count){
        imageView.image = [UIImage imageNamed:@"ic_add_photo"];
    }else{
        imageView.image = nil;
    }
    
    UIButton *cancleBtn = [[UIButton alloc]init];
    cell.cancleBtn = cancleBtn;
    [cell.contentView addSubview: cancleBtn];
    [cancleBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    cancleBtn.hidden = YES;//初始将删除按钮隐藏
    cell.cancleBtn.tag = indexPath.row;
    [cell.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake((cell.width-23)/2.0, (cell.height-23)/2.0, 23, 23)];
    videoIcon.image = [UIImage imageNamed:@"ic_video_preview"];;
    videoIcon.layer.masksToBounds = YES;
    videoIcon.contentMode = UIViewContentModeScaleAspectFit;
    videoIcon.hidden = YES;
    [cell.contentView addSubview:videoIcon];
    cell.videoIcon =videoIcon;
    
    cell.imageView.frame = CGRectMake(0, 0, imageSize, imageSize);
    cell.cancleBtn.frame = CGRectMake(imageSize-20, 0, 20, 20);
    
    
    if (self.imageArray.count > indexPath.row) {
        QMImageModel *imageInfo = self.imageArray[indexPath.row];
        cell.imageView.image = nil;
        if (imageInfo.image) {
            cell.imageView.image = imageInfo.image;
        } else {
            [cell.imageView setImageWithURLString:imageInfo.imageUrl placeholderImage:kDefaultLoadingImage];
        }
        cell.cancleBtn.hidden = NO;
        cell.videoIcon.hidden = !imageInfo.isVideo;
    }
}

- (void)uploadImages
{
    if (self.cacheImageArray.count) {
        [self.uploadPicManager loadDataWithHUDOnView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)reload
{
    [self.collectionView reloadData];
    if (self.imagePickerBlock) {
        self.imagePickerBlock(self.imageArray);
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageArray.count<=indexPath.row) {
        [QMUtil hiddenKeyboard];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *shortVideoAction = [UIAlertAction actionWithTitle:@"小视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            QMShortVideoController *shortVideoVC = [[QMShortVideoController alloc] init];
            WS(weakSelf);
            shortVideoVC.shortVideoSuccessBlock = ^(QMImageModel *videoInfo) {
                [weakSelf.imageArray addObject:videoInfo];
                [weakSelf reload];
            };
            [kRootNavigation pushViewController:shortVideoVC animated:YES];
        }];
        [alertController addAction:shortVideoAction];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = (id)self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = sourceType;
                [kRootNavigation presentViewController:imagePicker animated:YES completion:nil];
            }else {
                NSLog(@"模拟器无法调用相机");
            }
        }];
        [alertController addAction:takePhotoAction];
        UIAlertAction *pickPhotoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImageCount-self.imageArray.count delegate:self];
            [kRootNavigation presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        [alertController addAction:pickPhotoAction];
        [kRootNavigation presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    QMImageModel *imageInfo = self.imageArray[indexPath.row];
    if (imageInfo.isVideo) {
        NSString *videoPath = [[CacheManager sharedCacheManager] inquiryVideoCache:imageInfo.videoUrl];
        if (videoPath && [[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
            UIImage *image = [UIImage pk_previewImageWithVideoURL:[NSURL fileURLWithPath:videoPath]];
            PKFullScreenPlayerViewController *vc = [[PKFullScreenPlayerViewController alloc] initWithVideoPath:videoPath previewImage:image];
            [kRootNavigation presentViewController:vc animated:NO completion:NULL];
        }
    } else {
        PictureFullScreenBrowser *browser = [[PictureFullScreenBrowser alloc] init];
        [browser setDelegate:self];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [browser showFormView:cell picturesCount:self.imageArray.count currentPictureIndex:indexPath.row];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    if (!isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            [self.cacheImageArray addObject:image];
        }
        [self uploadImages];
    } else {
        WS(weakSelf);
        for (int i=0; i<assets.count; i++) {
            id asset = assets[i];
            [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
                [weakSelf.cacheImageArray addObject:photo];
                if (i==assets.count-1) {
                    [weakSelf uploadImages];
                }
            }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//裁剪后图片
    [kRootNavigation dismissViewControllerAnimated:YES completion:nil];
    [self.cacheImageArray addObject:image];
    [self uploadImages];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [kRootNavigation dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PictureFullScreenBrowserDelegate
/**
 获取对应索引的视图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 视图
 */
- (UIView *)pictureView:(PictureFullScreenBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    QMImagePickerCell *cell = (QMImagePickerCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell.imageView;
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(PictureFullScreenBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    QMImageModel *imageData = self.imageArray[index];
    return imageData.imageUrl;
}

- (UIImage *)pictureView:(PictureFullScreenBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index
{
    QMImageModel *imageData = self.imageArray[index];
    return imageData.image;
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(BaseAPIManager *)manager
{
    NSMutableDictionary *picDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *name = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",name];
    picDic[@"key"] = name;
    picDic[@"pic"] = fileName;
    return @{@"picMap":picDic};
}

- (void (^)(id <AFMultipartFormData> formData))uploadBlock:(BaseAPIManager *)manager
{
    if (manager==self.uploadPicManager) {
        return ^(id<AFMultipartFormData> formData) {
            UIImage *image = self.cacheImageArray[0];
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *name = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",name];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpg" ];
        };
    }
    return nil;
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager
{
    QMImageModel *imageInfo = [[QMImageModel alloc] init];
    imageInfo.image = self.cacheImageArray[0];
    imageInfo.imageUrl = self.uploadPicManager.picUrl;
    [self.imageArray addObject:imageInfo];
    [self reload];
    [self.cacheImageArray removeObjectAtIndex:0];
    if (self.cacheImageArray.count) {
        [self uploadImages];
    } else {
        [MBProgressHUD showTip:@"图片上传成功"];
    }
}

- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager
{
    [MBProgressHUD showTip:manager.errorMessage];
    [self.cacheImageArray removeAllObjects];
}

#pragma mark - actions
- (void)cancleBtnClick:(UIButton *)sender
{
    if (sender.tag < self.imageArray.count) {
        [self.imageArray removeObjectAtIndex:sender.tag];
        sender.hidden = YES;
        [self reload];
    }
}

#pragma mark - getters and setters
-(void)setImageArray:(NSMutableArray *)imageArray
{
    if (imageArray) {
        _imageArray = imageArray;
    }
    [self.collectionView reloadData];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(imageSize, imageSize);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //    layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, imageSize, imageSize + 20) collectionViewLayout:layout];
        [_collectionView registerClass:[QMImagePickerCell class] forCellWithReuseIdentifier:collectionViewCellId];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

-(UploadPicManager *)uploadPicManager
{
    if (!_uploadPicManager) {
        _uploadPicManager = [[UploadPicManager alloc] init];
        _uploadPicManager.paramSource = (id)self;
        _uploadPicManager.delegate = (id)self;
        _uploadPicManager.validator = (id)_uploadPicManager;
    }
    return _uploadPicManager;
}

@end

@interface QMImagePickerCell ()
@end

@implementation QMImagePickerCell

@end

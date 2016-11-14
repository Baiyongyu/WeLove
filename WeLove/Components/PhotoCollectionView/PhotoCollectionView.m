//
//  MSAddPhotosView.m
//  JYG_Sales
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 WeShare. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "ZYQAssetPickerController.h"
#define leftMarign 15
#define topMarign 15

const CGFloat collectionHeaderH = 30;
const CGFloat collectionFooterH  = 40;

static NSString * const collectionCell = @"photoCell";
static NSString * const collectionHead = @"headerView";
static NSString * const collectionFoot = @"footerView";

@interface PhotoCollectionView () <ZYQAssetPickerControllerDelegate, UINavigationBarDelegate,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *photoCollectionView;
@property(nonatomic,strong)ZYQAssetPickerController *picker;
@end
@implementation PhotoCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.columeCount = 4;
        self.heightWidthRatio = 1.0;
        self.maxPhotoCount = 10;
    }
    return self;
}

-(void)initUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 1;
    self.photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) collectionViewLayout:flowLayout];
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = (id)self;
    self.photoCollectionView.bounces = NO;
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.photoCollectionView];
    
    [self.photoCollectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:collectionCell];
    [self.photoCollectionView registerClass:[PhotoCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHead];
    [self.photoCollectionView registerClass:[PhotoCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                     withReuseIdentifier:collectionFoot];


    self.backgroundColor = kDarkGrayColor;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray=nil;
    _dataArray = [dataArray mutableCopy]?:[NSMutableArray array];
    self.photoUrls = [_dataArray mutableCopy];
    [self reloadCollectionView];
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    if (_editable) {
        self.dataArray = self.dataArray;
    }
}

- (void)setHeadertitle:(NSString *)headertitle
{
    _headertitle = headertitle;
    [self.photoCollectionView reloadData];
}

- (void)reloadCollectionView
{
    [self.photoCollectionView reloadData];
    [self performBlock:^{
        self.height = self.photoCollectionView.contentSize.height;
        self.photoCollectionView.height = self.photoCollectionView.contentSize.height;
        if ([self.delegate respondsToSelector:@selector(photoCollectionViewUpdate)]) {
            [self.delegate photoCollectionViewUpdate];
        }
    } afterDelay:0.1];
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.editable) {
        return self.dataArray.count;
    }
    return MIN(self.dataArray.count+1,self.maxPhotoCount);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    cell.delegate = (id)self;
    cell.indexPath = indexPath;
    cell.enableEdit = self.editable;
    cell.showRemoveBtn = self.editable;
    cell.hidden = NO;
    if (indexPath.row >= self.dataArray.count)
    {
        cell.showRemoveBtn = NO;
        if (indexPath.row>=self.maxPhotoCount)
        {  // 不显示添加item
            cell.hidden=YES;
        }
        cell.photoImage = [UIImage imageNamed:@"ic_add_photo"];
    } else {
        if ([self.dataArray[indexPath.row] isKindOfClass:[UIImage class]]) {
            cell.photoImage = self.dataArray[indexPath.row];
        } else if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.photoImageUrl = self.dataArray[indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/self.columeCount-20, (kScreenWidth/self.columeCount-20)*self.heightWidthRatio);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

#pragma mark - MSPhotoCellDelegate

- (void)photoCellDeletePhotoAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.photoUrls removeObjectAtIndex:indexPath.row];
    [self reloadCollectionView];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        PhotoCollectionHeadView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        if (self.headertitle.length) {
            reusableView.title=self.headertitle;
        } else if (self.attributeheadertitle.length) {
            reusableView.attributeTitle=self.attributeheadertitle;
        }
        return reusableView;
    }
    else
    {
        if (self.hiddenFooterView) {
            return nil;
        }
        PhotoCollectionFooterView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerView" forIndexPath:indexPath];

        reusableView.num = MIN(self.dataArray.count,self.maxPhotoCount);
        return reusableView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.attributeheadertitle.length) {
        CGSize size = [QMUtil sizeWithString:self.attributeheadertitle size:CGSizeMake(self.width-30, CGFLOAT_MAX)];
        return CGSizeMake(self.width, size.height+15);
    }
    if (self.headertitle.length) {
        return CGSizeMake(self.width, collectionHeaderH);
    }
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.hiddenFooterView) {
        return CGSizeZero;
    }
    return CGSizeMake(self.width,collectionFooterH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.editable) {
        return;
    }
    [QMUtil hiddenKeyboard];
    // 已经选择的照片不允许点击
    if (!self.dataArray.count || indexPath.item>(self.dataArray.count-1)) {
        UIActionSheet *selectPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照",nil];
        selectPhotoActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        selectPhotoActionSheet.delegate = (id)self;
        [selectPhotoActionSheet showInView:self.photoCollectionView];
    }
}

#pragma mark -actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        
    }
    switch (buttonIndex) {
        case 0:
        {
            [self openLocalAlbum];
        }
            break;
        case 1:
        {
            [self takePhoto];
        }
            break;
        default:
            break;
    }
}

#pragma mark -takePhoto
- (void)takePhoto {
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
}

- (void)openLocalAlbum
{
    self.picker = [[ZYQAssetPickerController alloc] init];
    self.picker.maximumNumberOfSelection = self.maximumNumberOfSelection?MIN(self.maxPhotoCount - self.dataArray.count, self.maximumNumberOfSelection?:1):self.maxPhotoCount - self.dataArray.count;
    self.picker.assetsFilter = [ALAssetsFilter allPhotos];
    self.picker.showEmptyGroups=NO;
    self.picker.delegate=(id)self;
    self.picker.showCancelButton = YES;
    self.picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];

    [kRootNavigation presentViewController:self.picker animated:YES completion:NULL];
}

#pragma mark - pickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//裁剪后图片
    [kRootNavigation dismissViewControllerAnimated:YES completion:nil];
    [self.dataArray addObject:image];
    [self.photoUrls addObject:image];
    self.picker.maximumNumberOfSelection = self.maximumNumberOfSelection?MIN(self.maxPhotoCount - self.dataArray.count, self.maximumNumberOfSelection?:1):self.maxPhotoCount - self.dataArray.count;
    [self reloadCollectionView];
    if ([self.delegate respondsToSelector:@selector(photoCollectionView:addPhoto:)]) {
        [self.delegate photoCollectionView:self addPhoto:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [kRootNavigation dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++)
    {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.dataArray addObject:tempImg];
        [self.photoUrls addObject:tempImg];
        if ([self.delegate respondsToSelector:@selector(photoCollectionView:addPhoto:)]) {
            [self.delegate photoCollectionView:self addPhoto:tempImg];
        }
    }
    
    self.picker.maximumNumberOfSelection = self.maximumNumberOfSelection?MIN(self.maxPhotoCount - self.dataArray.count, self.maximumNumberOfSelection?:1):self.maxPhotoCount - self.dataArray.count;
   [self reloadCollectionView];

}

@end

@interface PhotoCollectionCell ()
@property(nonatomic,strong)UIImageView *photo;
@property(nonatomic,strong)QMButton *removeBtn;
@end
@implementation PhotoCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, self.width-7.5, self.height-7.5)];
        self.photo.userInteractionEnabled = YES;
        self.photo.layer.cornerRadius = 3;
        self.photo.clipsToBounds = YES;
        [self.contentView addSubview:self.photo];
        
        self.removeBtn = [QMButton buttonWithType:UIButtonTypeCustom];
        self.removeBtn.frame = CGRectMake(self.width-40, 0, 40, 40);
        self.removeBtn.imageViewFrame = CGRectMake(25, 0, 15, 15);
        self.removeBtn.relayout = YES;
        [self.removeBtn addTarget:self action:@selector(removePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.removeBtn setImage:[UIImage imageNamed:@"ic_remove"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.removeBtn];
        self.removeBtn.hidden = YES;
    }
    return self;
}

- (void)setPhotoImage:(UIImage *)photoImage
{
    _photoImage = photoImage;
    self.photo.image = photoImage;
}

- (void)setPhotoImageUrl:(NSString *)photoImageUrl
{
    _photoImageUrl = photoImageUrl;
    [self.photo setImageWithURLString:_photoImageUrl placeholderImage:nil];
}

- (void)setEnableEdit:(BOOL)enableEdit
{
    _enableEdit = enableEdit;
    self.photo.enableFullScreen = @(!enableEdit);
}

- (void)setShowRemoveBtn:(BOOL)showRemoveBtn
{
    _showRemoveBtn = showRemoveBtn;
    self.removeBtn.hidden = !showRemoveBtn;
}

- (void)removePhoto
{
    if ([self.delegate respondsToSelector:@selector(photoCellDeletePhotoAtIndexPath:)]) {
        [self.delegate photoCellDeletePhotoAtIndexPath:self.indexPath];
    }
   
}

@end



@interface PhotoCollectionHeadView ()
@property UILabel* titleLabel;
@end
@implementation PhotoCollectionHeadView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        CGRect rect=CGRectMake(15, 10,self.width-30, 20);
        self.titleLabel=[[UILabel alloc] initWithFrame:rect];
        self.titleLabel.font=XiHeiFont(16);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = kDarkGrayColor;
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title=title;
    self.titleLabel.text=title;
}

- (void)setAttributeTitle:(NSAttributedString *)attributeTitle
{
    _attributeTitle = attributeTitle;
    CGSize size = [QMUtil sizeWithString:attributeTitle size:CGSizeMake(self.width-30, CGFLOAT_MAX)];
    self.titleLabel.height = size.height+5;
    self.titleLabel.attributedText = attributeTitle;
}

@end


#pragma mark - define PromoteFoot
@interface PhotoCollectionFooterView ()
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)UIImageView* tipImg;

@end
@implementation PhotoCollectionFooterView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(leftMarign, 13, 14, 14)];
    self.tipImg.image = [UIImage imageNamed:@"pic"];
    [self  addSubview:self.tipImg];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tipImg.right + 5, 10, kScreenWidth - leftMarign - 17 - 5, 20)];
    [self addSubview:self.titleLabel];
}

- (void)setNum:(NSInteger)num
{
    _num = num;
    NSDictionary * att = @{NSForegroundColorAttributeName: kBlueColor, NSFontAttributeName: [UIFont systemFontOfSize:12]};
    NSMutableAttributedString *number = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%zi", num] attributes:att];
    NSAttributedString *numberAtt = [[NSAttributedString alloc] initWithString:@"/10  最多可上传10张照片" attributes:@{NSForegroundColorAttributeName: kDarkGrayColor, NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    [number appendAttributedString:numberAtt];
    self.titleLabel.attributedText = number;

}
@end

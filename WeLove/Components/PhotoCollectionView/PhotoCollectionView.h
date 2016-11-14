//
//  MSAddPhotosView.h
//  JYG_Sales
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 WeShare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoCollectionView;
@protocol PhotoCollectionViewDelegate <NSObject>
- (void)photoCollectionViewUpdate;
- (void)photoCollectionView:(PhotoCollectionView *)photoCollectionView addPhoto:(UIImage *)photo;
@end
@interface PhotoCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,retain)NSMutableArray *photoUrls;
@property(nonatomic,weak)id<PhotoCollectionViewDelegate> delegate;
@property(nonatomic,copy)NSString *headertitle;
@property(nonatomic,copy)NSAttributedString *attributeheadertitle;
//每行显示图片数量
@property(nonatomic,assign)int columeCount;
//图片高宽比
@property(nonatomic,assign)CGFloat heightWidthRatio;
//最大图片数量
@property(nonatomic,assign)int maxPhotoCount;
//是否显示底部数量视图
@property(nonatomic,assign)BOOL hiddenFooterView;
//单次最多选择图片数量
@property(nonatomic,assign)NSInteger maximumNumberOfSelection;
@property(nonatomic,assign)BOOL editable;
@end

@protocol PhotoCollectionCellDelegate <NSObject>
- (void)photoCellDeletePhotoAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface PhotoCollectionCell : UICollectionViewCell
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIImage *photoImage;
@property(nonatomic,copy)NSString *photoImageUrl;
@property(nonatomic,assign)BOOL enableEdit;
@property(nonatomic,assign)BOOL showRemoveBtn;
@property(nonatomic,weak)id<PhotoCollectionCellDelegate> delegate;
@end

#pragma mark - define PromoteHead
@interface PhotoCollectionHeadView : UICollectionReusableView
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSAttributedString* attributeTitle;
@end

#pragma mark - define PromoteFoot
@interface PhotoCollectionFooterView : UICollectionReusableView
@property (nonatomic , assign) NSInteger num;
@end

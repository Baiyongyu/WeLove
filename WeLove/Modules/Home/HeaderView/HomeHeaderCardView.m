//
//  HomeHeaderCardView.m
//  LoveLove
//
//  Created by 宇玄丶 on 2016/11/26.
//  Copyright © 2016年 北京116科技有限公司. All rights reserved.
//

#import "HomeHeaderCardView.h"
#import "HomeCollectionCardViewCell.h"

static NSString *reuseIdentifier = @"Cell";

@interface HomeHeaderCardView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HomeCollectionCardFlowLayout *layout;

@end

@implementation HomeHeaderCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        // 动画展示
        [self.collectionView.layer addAnimation:GetPopAnimation() forKey:nil];
    }
    return self;
}


#pragma mark UICollectionViewDatasoure
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCollectionCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageName = self.imageArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(didSeletedViewItem:)]) {
        [_delegate didSeletedViewItem:indexPath];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[HomeCollectionCardFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)
                                             collectionViewLayout:_layout];
        _layout.itemSize = CGSizeMake(200, 250);
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionCardViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        for (int i = 0 ; i < 27; i++) {
            [_imageArray addObject:[NSString stringWithFormat:@"WechatIMG%d.jpeg",i]];
        }
    }
    return _imageArray;
}

@end

#pragma mark - HomeCollectionCardFlowLayout
@implementation HomeCollectionCardFlowLayout

// 显示范围发生变化后是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
// 滚动停止后collectionview的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect CurrentRect;
    CurrentRect.origin.x = proposedContentOffset.x;
    CurrentRect.origin.y = 0;
    CurrentRect.size = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:CurrentRect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width*0.5;
    
    CGFloat MinMarin = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *arr in array) {
        if (ABS(MinMarin) > ABS(arr.center.x - centerX)) {
            MinMarin = arr.center.x - centerX;
        }
    }
    proposedContentOffset.x+=MinMarin;
    return proposedContentOffset;
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //获取super计算的布局属性
    NSArray *arrary = [super layoutAttributesForElementsInRect:rect];
    //计算collectionview中心的X
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *arrs in arrary) {
        //cell中心和collectionview的中心距离
        CGFloat margin = ABS(centerX- arrs.center.x);
        //cell缩放比例
        CGFloat scale = 1 - (margin /self.collectionView.frame.size.width * 0.5);
        if (scale > 0.9) {
            arrs.alpha = 1;
        }else {
            arrs.alpha = 0.7;
        }
        arrs.transform3D = CATransform3DMakeScale(scale, scale, scale);
    }
    return arrary;
}
// 布局的初始化
- (void)prepareLayout {
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat insert = (self.collectionView.frame.size.width - self.itemSize.width)*0.5;
    
    self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert);
}
// 重新刷新布局时候调用
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *arrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return arrs;
}
@end




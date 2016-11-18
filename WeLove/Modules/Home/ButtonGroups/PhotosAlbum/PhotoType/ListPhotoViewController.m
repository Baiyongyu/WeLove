//
//  ListPhotoViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "ListPhotoViewController.h"

#define cellHeight 250

@interface ListPhotoViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation ListPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultViewBackgroundColor;
    [self layoutConstraints];
    [self loadData];
}

- (void)layoutConstraints {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kDefaultViewBackgroundColor;
    [self.view addSubview:_tableView];
}

- (void)loadData {
    _dataArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 28; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"WechatIMG%d.jpeg",i]];
        [_dataArray addObject:image];
    }
}

#pragma mark ---------tableView-----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    return cell;
}

// 在willDisplayCell里面处理数据能优化tableview的滑动流畅性
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell * myCell = (MyCell *)cell;
    
    [myCell setImg:_dataArray[indexPath.row]];
    [myCell cellOffset];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // visibleCells 获取界面上能显示出来了cell
    NSArray<MyCell *> *array = [self.tableView visibleCells];
    
    //enumerateObjectsUsingBlock 类似于for，但是比for更快
    [array enumerateObjectsUsingBlock:^(MyCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj cellOffset];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation MyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //取消选中效果
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        //裁剪看不到的
        self.clipsToBounds = YES;
        
        //pictureView的Y往上加一半cellHeight 高度为2 * cellHeight，这样上下多出一半的cellHeight
        _pictureView = ({
            UIImageView * picture = [[UIImageView alloc]initWithFrame:CGRectMake(0, -cellHeight/2, kScreenWidth, cellHeight * 2)];
            picture.contentMode = UIViewContentModeScaleAspectFill;
            picture;
        });
        [self.contentView  addSubview:_pictureView];
        
        _coverview = ({
            UIView * coverview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, cellHeight)];
            coverview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
            coverview;
        });
        //[self.contentView addSubview:_coverview];
        
        _titleLabel = ({
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cellHeight / 2 - 30, kScreenWidth, 30)];
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = @"微爱";
            titleLabel;
        });
        [self.contentView addSubview:_titleLabel];
        
        _littleLabel = ({
            UILabel * littleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cellHeight / 2 + 30, kScreenWidth, 30)];
            littleLabel.font = [UIFont systemFontOfSize:14];
            littleLabel.textAlignment = NSTextAlignmentCenter;
            littleLabel.textColor = [UIColor whiteColor];
            littleLabel.text = @"小v爱宇哥";
            littleLabel;
        });
        [self.contentView addSubview:_littleLabel];
    }
    return self;
}

- (CGFloat)cellOffset {
    /*
     - (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
     将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
     这里用来获取self在window上的位置
     */
    CGRect toWindow = [self convertRect:self.bounds toView:self.window];
    
    //获取父视图的中心
    CGPoint windowCenter = self.superview.center;
    
    //cell在y轴上的位移  CGRectGetMidY之前讲过,获取中心Y值
    CGFloat cellOffsetY = CGRectGetMidY(toWindow) - windowCenter.y;
    
    //位移比例
    CGFloat offsetDig = 2 * cellOffsetY / self.superview.frame.size.height ;
    
    //要补偿的位移
    CGFloat offset =  -offsetDig * cellHeight/2;
    
    //让pictureViewY轴方向位移offset
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    self.pictureView.transform = transY;
    
    return offset;
}

- (void)setImg:(UIImage *)img {
    self.pictureView.image = img;
}

@end





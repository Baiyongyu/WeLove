//
//  Header.h
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/23.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#ifndef Header_h
#define Header_h


//
//  MineViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/13.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "MineViewController.h"
/** Nav */
#import "NavHeadTitleView.h"
/** headView */
#import "HeadImageView.h"
#import "HeadLineView.h"

#import "DayTimeCell.h"

#import "LineDayModel.h"
#import "LineMonthModel.h"
#import "LineDisplayModel.h"

#import "BirdFlyViewController.h" // 飞翔小鸟

@interface MineViewController ()<NavHeadTitleViewDelegate,headLineDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //头像
    UIImageView *_headerImg;
    //昵称
    UILabel *_nickLabel;
    NSMutableArray *_dataArray0;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
}
@property(nonatomic,strong)UIImageView *backgroundImgV;//背景图
/** 头部 */
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,assign)float backImgOrgy;
@property(nonatomic,strong)NavHeadTitleView *NavView;//导航栏
@property(nonatomic,strong)HeadImageView *headImageView;//头视图
@property(nonatomic,strong)HeadLineView *headLineView;//

/** data*/
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)int rowHeight;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MineViewController

static NSString *cellTimeOne = @"DayTimeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 拉伸顶部图片
    [self lashenBgView];
    // 创建导航栏
    [self createNav];
    // 初始化数据源
    [self loadData];
    // 创建TableView
    [self createTableView];
}
#pragma mark - 创建数据源
- (void)loadData {
    _currentIndex = 0;
    _dataArray0 = [[NSMutableArray alloc]init];
    _dataArray1 = [[NSMutableArray alloc]init];
    _dataArray2 = [[NSMutableArray alloc]init];
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            
            LineDayModel *Model0 = [[LineDayModel alloc]initWithDay:@"5.1" imgArray:@[@"1",@"1",@"1"]];
            LineDayModel *Model1 = [[LineDayModel alloc]initWithDay:@"5.2" imgArray:@[@"1",@"1",@"1"]];
            LineDayModel *Model2 = [[LineDayModel alloc]initWithDay:@"5.3" imgArray:@[@"1",@"1",@"1"]];
            
            LineMonthModel *Model_0 = [[LineMonthModel alloc]initWithMonth:@"2016年5月" days:@[Model0,Model1, Model2]];
            
            _dataArray0 = [NSMutableArray arrayWithArray:@[Model_0]];
            
            
        }else if(i == 1) {
            for (int i = 1; i < 10; i++) {
                NSString *string = [NSString stringWithFormat:@"%d 小v",i];
                [_dataArray1 addObject:string];
            }
        }else if (i == 2){
            for (int i = 0; i < 10; i++) {
                NSString * string = [NSString stringWithFormat:@"测试 %d",i];
                [_dataArray2 addObject:string];
            }
        }
    }
}
#pragma mark - 拉伸顶部图片
- (void)lashenBgView {
    UIImage *image = [UIImage imageNamed:@"lbg41009"];
    _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    _backgroundImgV.image = image;
    _backgroundImgV.userInteractionEnabled = YES;
    _backImgHeight = _backgroundImgV.frame.size.height;
    _backImgWidth = _backgroundImgV.frame.size.width;
    _backImgOrgy = _backgroundImgV.frame.origin.y;
    [self.view addSubview:_backgroundImgV];
}
#pragma mark - 创建TableView
- (void)createTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerNib:[DayTimeCell nib] forCellReuseIdentifier:cellTimeOne];
        [self.view addSubview:_tableView];
    }
    [_tableView setTableHeaderView:[self headImageView]];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    UIView *targetview = sender.view;
    if(targetview.tag == 1) {
        return;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_currentIndex > 1) {
            return;
        }
        _currentIndex ++;
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentIndex <= 0) {
            return;
        }
        _currentIndex --;
    }
    [_headLineView setCurrentIndex:_currentIndex];
}
- (void)refreshHeadLine:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [_tableView reloadData];
}

#pragma mark - 头视图
- (HeadImageView *)headImageView {
    if (!_headImageView) {
        // 背景
        _headImageView = [[HeadImageView alloc]init];
        _headImageView.frame = CGRectMake(0, 64, kScreenWidth, 170);
        _headImageView.backgroundColor = [UIColor clearColor];
        // 头像
        _headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-35, 50, 70, 70)];
        _headerImg.center = CGPointMake(kScreenWidth/2, 70);
        [_headerImg setImage:[UIImage imageNamed:@"WechatIMG11.jpeg"]];
        [_headerImg.layer setMasksToBounds:YES];
        [_headerImg.layer setCornerRadius:35];
        _headerImg.backgroundColor = [UIColor whiteColor];
        _headerImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_headerImg addGestureRecognizer:tap];
        [_headImageView addSubview:_headerImg];
        // 昵称
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(147, 130, 105, 20)];
        _nickLabel.center = CGPointMake(kScreenWidth/2, 125);
        _nickLabel.text = @"宇哥爱小v";
        _nickLabel.textColor = [UIColor whiteColor];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        [_headImageView addSubview:_nickLabel];
    }
    return _headImageView;
}
// 头像点击事件
- (void)tapClick:(UITapGestureRecognizer *)recognizer {
    NSLog(@"修改头像");
}

#pragma mark - 创建导航栏
- (void)createNav {
    self.NavView = [[NavHeadTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.NavView.title = @"个人中心";
    self.NavView.color = [UIColor whiteColor];
    self.NavView.rightTitleImage = @"Setting";
    self.NavView.delegate = self;
    [self.view addSubview:self.NavView];
}
// 右按钮回调
- (void)NavHeadToRight {
    NSLog(@"点击了右按钮");
    //    BirdFlyViewController *birdVC = [[BirdFlyViewController alloc] init];
    //    [kRootNavigation pushViewController:birdVC animated:YES];
}

#pragma mark ---- UITableViewDelegate ----
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentIndex == 0) {
        return 86;
    }
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentIndex == 0) {
        LineMonthModel *mModel = _dataArray0[section];
        return mModel.monthRows;
    }else if(_currentIndex == 1){
        return _dataArray1.count;
    }
    return _dataArray2.count;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_headLineView) {
        _headLineView = [[HeadLineView alloc]init];
        _headLineView.frame = CGRectMake(0, 0, kScreenWidth, 48);
        _headLineView.delegate = self;
        [_headLineView setTitleArray:@[@"日鉴",@"阅读",@"我们的资料"]];
    }
    return _headLineView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reusID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusID];
    }
    if (_currentIndex == 0) {
        
        LineMonthModel *mModel = _dataArray0[indexPath.section];
        LineDisplayModel *dModel = mModel.displayArray[indexPath.row];
        if (dModel.isFirst) {
            DayTimeCell *tempCell = [tableView dequeueReusableCellWithIdentifier:cellTimeOne];
            [tempCell refreshUIWithImageArray:dModel.imgArray time:dModel.day];
            cell = tempCell;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(_currentIndex == 1) {
        
        cell.textLabel.text = [_dataArray1 objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_dataArray1 objectAtIndex:indexPath.row];
        [cell.imageView setImage:[UIImage imageNamed:@"WechatIMG9.jpeg"]];
        
        return cell;
    }else if(_currentIndex == 2) {
        cell.textLabel.text = [_dataArray2 objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_dataArray2 objectAtIndex:indexPath.row];
        [cell.imageView setImage:[UIImage imageNamed:@"WechatIMG10.jpeg"]];
        
        return cell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentIndex == 0) {
        
    } else if (_currentIndex == 1) {
        
    }else {
    }
}

#pragma mark - 导航栏渐变效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y <= 170) {
        self.NavView.headBgView.alpha = scrollView.contentOffset.y/170;
        self.NavView.rightImageView = @"Setting";
        self.NavView.color = [UIColor whiteColor];
        //状态栏字体白色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else {
        self.NavView.headBgView.alpha = 1;
        self.NavView.rightImageView = @"Setting-click";
        self.NavView.color = kNavColor;
        //隐藏黑线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        // 状态栏字体黑色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    if (contentOffsety < 0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight - contentOffsety;
        rect.size.width = _backImgWidth * (_backImgHeight - contentOffsety)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _backgroundImgV.frame = rect;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


#endif /* Header_h */

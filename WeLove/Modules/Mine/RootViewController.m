//
//  RootViewController.m
//  MineHeadDemo
//
//  Created by 吉祥 on 16/9/9.
//  Copyright © 2016年 jixiang. All rights reserved.
//

#import "RootViewController.h"
#import "NavHeadTitleView.h"
#import "HeadImageView.h"
#import "HeadLineView.h"


#import "TimeHeader.h"
#import "TimeOneCell.h"
#import "TimeTwoCell.h"

#import "LineDayModel.h"
#import "LineMonthModel.h"
#import "LineDisplayModel.h"


#import "BirdFlyViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
//颜色
#define JXColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface RootViewController ()<NavHeadTitleViewDelegate,headLineDelegate,UITableViewDataSource,UITableViewDelegate>
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
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,assign)float backImgOrgy;
@property(nonatomic,strong)NavHeadTitleView *NavView;//导航栏
@property(nonatomic,strong)HeadImageView *headImageView;//头视图
@property(nonatomic,strong)HeadLineView *headLineView;//
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)int rowHeight;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation RootViewController

static NSString * cellTimeOne = @"cellTimeOne";
static NSString * cellTimeTwo = @"cellTimeTwo";

- (void)viewDidLoad {
    [super viewDidLoad];
    //拉伸顶部图片
    [self lashenBgView];
    //创建导航栏
    [self createNav];
    //初始化数据源
    [self loadData];
    //创建TableView
    [self createTableView];
}
//创建数据源
-(void)loadData{
    _currentIndex=0;
    _dataArray0=[[NSMutableArray alloc]init];
    _dataArray1=[[NSMutableArray alloc]init];
    _dataArray2=[[NSMutableArray alloc]init];
    for (int i=0; i < 3; i++) {
        if (i == 0) {
            
            LineDayModel *lModel00 = [[LineDayModel alloc]initWithDay:@"5.1" imgArray:@[@"1",@"2"]];
            LineDayModel *lModel01 = [[LineDayModel alloc]initWithDay:@"5.2" imgArray:@[@"1",@"2",@"3",@"4",@"1"]];
            LineDayModel *lModel02 = [[LineDayModel alloc]initWithDay:@"5.3" imgArray:@[@"1",@"2",@"1"]];
            
            LineMonthModel *lmModel0 = [[LineMonthModel alloc]initWithMonth:@"2016年5月" days:@[lModel00,lModel01, lModel02]];
            
            
            LineDayModel *lModel10 = [[LineDayModel alloc]initWithDay:@"6.1" imgArray:@[@"1",@"3",@"1"]];
            LineDayModel *lModel11 = [[LineDayModel alloc]initWithDay:@"6.2" imgArray:@[@"1",@"2",@"4"]];
            
            
            LineMonthModel *lmModel1 = [[LineMonthModel alloc]initWithMonth:@"2016年6月" days:@[lModel10,lModel11]];
            
            
            LineDayModel *lModel20 = [[LineDayModel alloc]initWithDay:@"7.1" imgArray:@[@"2",@"3",@"1",@"3",@"1"]];
            LineDayModel *lModel21 = [[LineDayModel alloc]initWithDay:@"7.2" imgArray:@[@"3",@"2",@"1",@"3",@"1",@"3",@"1",@"3",@"1"]];
            
            LineMonthModel *lmModel2 = [[LineMonthModel alloc]initWithMonth:@"2016年7月" days:@[lModel20,lModel21]];
            
            _dataArray0 = [NSMutableArray arrayWithArray:@[lmModel0,lmModel1,lmModel2]];
            
            for (LineMonthModel *mModel in _dataArray0) {
                mModel.shouldOpen = YES;
            }
            
        }else if(i == 1){
            for (int i=1; i<8; i++) {
                NSString * string=[NSString stringWithFormat:@"%d 娃",i];
                [_dataArray1 addObject:string];
            }
        }else if (i == 2){
            for (int i=0; i<3; i++) {
                NSString * string=[NSString stringWithFormat:@"this is %d",i];
                [_dataArray2 addObject:string];
            }
        }
    }
}
//拉伸顶部图片
-(void)lashenBgView{
    UIImage *image=[UIImage imageNamed:@"bg-mine"];
    //图片的宽度设为屏幕的宽度，高度自适应
    NSLog(@"%f",image.size.height);
    _backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, image.size.height*0.6)];
    _backgroundImgV.image=image;
    _backgroundImgV.userInteractionEnabled=YES;
    [self.view addSubview:_backgroundImgV];
    _backImgHeight=_backgroundImgV.frame.size.height;
    _backImgWidth=_backgroundImgV.frame.size.width;
    _backImgOrgy=_backgroundImgV.frame.origin.y;
}
//创建TableView
-(void)createTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        [_tableView registerNib:[TimeOneCell nib] forCellReuseIdentifier:cellTimeOne];
        [_tableView registerNib:[TimeTwoCell nib] forCellReuseIdentifier:cellTimeTwo];
        [self.view addSubview:_tableView];
    }
    [_tableView setTableHeaderView:[self headImageView]];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    UIView *targetview = sender.view;
    if(targetview.tag == 1) {
        return;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_currentIndex>1) {
            return;
        }
        _currentIndex++;
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentIndex<=0) {
            return;
        }
        _currentIndex--;
    }
    [_headLineView setCurrentIndex:_currentIndex];
}
-(void)refreshHeadLine:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    [_tableView reloadData];
}

//头视图
-(HeadImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[HeadImageView alloc]init];
        _headImageView.frame=CGRectMake(0, 64, WIDTH, 170);
        _headImageView.backgroundColor=[UIColor clearColor];
        
        //_headImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"个人页背景图.png"]];
        
        _headerImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-35, 50, 70, 70)];
        _headerImg.center=CGPointMake(WIDTH/2, 70);
        [_headerImg setImage:[UIImage imageNamed:@"WechatIMG11.jpeg"]];
        [_headerImg.layer setMasksToBounds:YES];
        [_headerImg.layer setCornerRadius:35];
        _headerImg.backgroundColor=[UIColor whiteColor];
        _headerImg.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_headerImg addGestureRecognizer:tap];
        [_headImageView addSubview:_headerImg];
        //昵称
        _nickLabel=[[UILabel alloc]initWithFrame:CGRectMake(147, 130, 105, 20)];
        _nickLabel.center=CGPointMake(WIDTH/2, 125);
        _nickLabel.text=@"宇哥爱小v";
//        _nickLabel.font=JXFont(14);
        _nickLabel.textColor=[UIColor whiteColor];
        _nickLabel.textAlignment=NSTextAlignmentCenter;
        UIButton *fixBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        fixBtn.frame=CGRectMake(CGRectGetMaxX(_nickLabel.frame)+5, 114, 22, 22);
        [fixBtn setImage:[UIImage imageNamed:@"pencil-light-shadow"] forState:UIControlStateNormal];
        [fixBtn addTarget:self action:@selector(fixClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headImageView addSubview:fixBtn];
        [_headImageView addSubview:_nickLabel];
    }
    return _headImageView;
}
//头像点击事件
-(void)tapClick:(UITapGestureRecognizer *)recognizer{
    NSLog(@"你打到我的头了");
}
//修改昵称
-(void)fixClick:(UIButton *)btn{
    NSLog(@"修改昵称");
}
-(void)createNav{
    self.NavView=[[NavHeadTitleView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    self.NavView.title=@"个人中心";
    self.NavView.color=[UIColor whiteColor];
    self.NavView.backTitleImage=@"Mail";
    self.NavView.rightTitleImage=@"Setting";
    self.NavView.delegate=self;
    [self.view addSubview:self.NavView];
}
//左按钮
-(void)NavHeadback{
    NSLog(@"点击了左按钮");
}
//右按钮回调
-(void)NavHeadToRight{
    NSLog(@"点击了右按钮");
    BirdFlyViewController *birdVC = [[BirdFlyViewController alloc] init];
    [kRootNavigation pushViewController:birdVC animated:YES];
}

#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndex == 0) {
        return 86;
    }
    return 120;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _dataArray0.count;
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentIndex==0) {
        LineMonthModel *mModel = _dataArray0[section];
        return mModel.monthRows;
    }else if(_currentIndex==1){
        return _dataArray1.count;
    }else{
        return _dataArray2.count;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headLineView) {
        _headLineView=[[HeadLineView alloc]init];
        _headLineView.frame=CGRectMake(0, 0, WIDTH, 48);
        _headLineView.delegate=self;
        [_headLineView setTitleArray:@[@"日鉴",@"阅读",@"我们的资料"]];
    }
    //如果headLineView需要添加图片，请到HeadLineView.m中去设置就可以了，里面有注释
    
    return _headLineView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *reusID=@"ID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reusID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusID];
    }
    if (_currentIndex==0) {
        
        LineMonthModel *mModel = _dataArray0[indexPath.section];
        LineDisplayModel *dModel = mModel.displayArray[indexPath.row];
        if (dModel.isFirst) {
            TimeOneCell *tempCell = [tableView dequeueReusableCellWithIdentifier:cellTimeOne];
            [tempCell refreshUIWithImageArray:dModel.imgArray time:dModel.day];
            cell = tempCell;
            
        }else{
            TimeTwoCell *tempCell = [tableView dequeueReusableCellWithIdentifier:cellTimeTwo];
            [tempCell refreshUIWithImageArray:dModel.imgArray];
            cell = tempCell;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(_currentIndex==1){
        cell.textLabel.text=[_dataArray1 objectAtIndex:indexPath.row];
        
        cell.detailTextLabel.text=[_dataArray1 objectAtIndex:indexPath.row];
        
        [cell.imageView setImage:[UIImage imageNamed:@"WechatIMG9.jpeg"]];
        
        return cell;
    }else if(_currentIndex==2){
        cell.textLabel.text=[_dataArray2 objectAtIndex:indexPath.row];
        
        cell.detailTextLabel.text=[_dataArray2 objectAtIndex:indexPath.row];
        
        [cell.imageView setImage:[UIImage imageNamed:@"WechatIMG10.jpeg"]];
        
        return cell;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentIndex==0) {
    }else if (_currentIndex==1){
    }else{
    }
}
//-(void)popView{
//    [self addAnimation];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y<=170) {
        self.NavView.headBgView.alpha=scrollView.contentOffset.y/170;
        self.NavView.backTitleImage=@"Mail";
        self.NavView.rightImageView=@"Setting";
        self.NavView.color=[UIColor whiteColor];
        //状态栏字体白色
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    }else{
        self.NavView.headBgView.alpha=1;
        //self.NavView.title
        self.NavView.backTitleImage=@"Mail-click";
        self.NavView.rightImageView=@"Setting-click";
        self.NavView.color=JXColor(87, 173, 104, 1);
        //隐藏黑线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        //状态栏字体黑色
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    }
    if (contentOffsety<0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight-contentOffsety;
        rect.size.width = _backImgWidth* (_backImgHeight-contentOffsety)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else{
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

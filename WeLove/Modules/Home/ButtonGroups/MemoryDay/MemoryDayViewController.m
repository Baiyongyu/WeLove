//
//  MemoryDayViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/14.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "MemoryDayViewController.h"

#import "FFMemberCenterHeadView.h"              // 头部视图
#import "HappinessTimeTableViewController.h"    // 幸福时光
#import "MTToViewTopButton.h"                   // 回到顶部
#import "TYWaveProgressView.h"  // 波浪


@interface MemoryDayViewController () 

/** Level */
@property (nonatomic, strong) FFMemberCenterHeadView *headView;
/** 在一起时间 */
@property (nonatomic,strong) NSString *dateContent;
/** 幸福时光 */
@property(nonatomic,strong)HappinessTimeTableViewController *happinessTimeTableVC;
/** 波浪 */
@property (nonatomic, weak) TYWaveProgressView *waveProgressView1;
@property (nonatomic, weak) TYWaveProgressView *waveProgressView2;

@end

@implementation MemoryDayViewController


- (void)loadSubViews {
    [super loadSubViews];
    self.titleLabel.text = @"纪念日";
    self.leftBtn.hidden = NO;
    
    
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.happinessTimeTableVC.view];
}

- (void)layoutConstraints {
    
    /***************************恋爱时间*****************************/
    self.headView = [[FFMemberCenterHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    
    // 计算在一起时间
    NSString *beginTime = [QMUtil getUTCFormateDate:@"2016-10-26 00:00"];
    NSLog(@"beginTime=%ld", [beginTime integerValue]);
    // 倒计时还有多少天见面
    NSString *jianTime = [QMUtil getUTCFormateDate:@"2016-12-02 00:00"];
    NSLog(@"jianmian=%ld",[jianTime integerValue]);
    
    /**
     * maxLevel 最高的等级 例如15  userLevel用户当前等级  userIntegral 用户积分 userlevelIntegral 用户当前等级积分 nextLevelIntegral 下个等级积分
     */
    [self.headView startIntegralAnimationWithMaxLevel:11 UserIntegral:[beginTime integerValue] UserLevel:9 UserlevelIntegral:3000 nextLevelIntegral:[jianTime integerValue] userNickName:@"" ActiveSize:CGSizeMake(180, 75) NormalSize:CGSizeMake(30, 35)];
    
    /***************************恋爱时光*****************************/
    WS(weakSelf);
    [self.happinessTimeTableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    self.happinessTimeTableVC.tableView.tableHeaderView = self.headView;
    
    /***************************回到顶部*****************************/
    MTToViewTopButton *topButton = [[MTToViewTopButton alloc] initWithFrame:CGRectMake(kScreenWidth - 55, kScreenHeight - 60, 40, 40) scrollView:(UIScrollView *)self.happinessTimeTableVC.view];
    topButton.showBtnOffset = 800;
    [self.view addSubview:topButton];
    
    /***************************波   浪*****************************/
    [self addWaveProgressView];
}

#pragma mark - 加载3D球数据
- (void)loadData {
    
    // 2016-11-24
    HappyTimeModel *activityData25 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData25 ActivityTime:@"2016-11-24" activityName:@"老婆回京啦" activityDetailInfo:@"好开心、老婆回京了，好几天没有视频了，想你..."];
    
    // 2016-11-23
    HappyTimeModel *activityData24 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData24 ActivityTime:@"2016-11-23" activityName:@"两支烟的痛" activityDetailInfo:@"如题、两支烟的痛..."];
    
    // 2016-11-22
    HappyTimeModel *activityData23 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData23 ActivityTime:@"2016-11-22" activityName:@"赌注" activityDetailInfo:@"老婆为了我、赌下了她一生的幸福；为了我、改变了初衷；为了我、放低了所有要求...我爱你、我们会永远幸福哒😘"];
    
    // 2016-11-21
    HappyTimeModel *activityData22 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData22 ActivityTime:@"2016-11-21" activityName:@"小v突然回家" activityDetailInfo:@"没有一点点防备，也没有一丝顾虑，就这么回家了。虽然没有告诉我原由，但隐约中猜到了大概。老婆很可怜，这一天基本没有工作，都在陪老婆，聊天、讲笑话，希望老婆能开心..."];
    
    // 2016-11-20
    HappyTimeModel *activityData21 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData21 ActivityTime:@"2016-11-20" activityName:@"妹妹、弟弟、幸福房子" activityDetailInfo:@"朋友说，来北京这段岁月，我是爱情事业双丰收，我们狠性福；并且丽姐也神奇的恋爱了，从此三姐妹都找到了归宿，我们有着一个群聊，叫做：永远的、幸福房子..."];
    
    // 2016-11-18
    HappyTimeModel *activityData20 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData20 ActivityTime:@"2016-11-18" activityName:@"肚子犯病了" activityDetailInfo:@"最近消化又不好了，天天吃完东西涨肚，不消化、难受..."];
    
    // 2016-11-17
    HappyTimeModel *activityData19 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData19 ActivityTime:@"2016-11-17" activityName:@"电话应邀" activityDetailInfo:@"总感觉小v工作，打电话约人，说的有问题，所以昨晚我们讨论了一个点，今天把电子版发来，我当起了小老师，帮小v参谋，改改词儿..."];
    
    // 2016-11-15
    HappyTimeModel *activityData18 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData18 ActivityTime:@"2016-11-15" activityName:@"微爱上传到GitHub" activityDetailInfo:@"之前都是用SVN，要不是第一次跟小v约会，让我给她讲Git，可能不会这么早接触。这下好了，啥都会啦，嘿嘿..."];
    
    // 2016-11-14
    HappyTimeModel *activityData17 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData17 ActivityTime:@"2016-11-14" activityName:@"第一次不开心" activityDetailInfo:@"因为宇哥回京消息暴露，小v不开心；剪发一事不开心，哎、14，真是要死啊..."];
    
    // 2016-11-12
    HappyTimeModel *activityData16 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData16 ActivityTime:@"2016-11-12" activityName:@"练习做菜" activityDetailInfo:@"小v喜欢吃鱼、可乐鸡翅，我要做好..."];
    
    // 2016-11-11
    HappyTimeModel *activityData15 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData15 ActivityTime:@"2016-11-11" activityName:@"今年双11不过节" activityDetailInfo:@"今年双11不过节，不只要你。亲爱的、有你真好！🌹🌹"];
    
    // 2016-11-9
    HappyTimeModel *activityData14 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData14 ActivityTime:@"2016-11-09" activityName:@"来自远方的关心" activityDetailInfo:@"亲爱的让我好好吃饭，有精力了才能赚钱给媳妇花~"];
    
    // 2016-11-8
    HappyTimeModel *activityData13 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData13 ActivityTime:@"2016-11-08" activityName:@"换卧室啦" activityDetailInfo:@"换小卧室啦，亲爱的上火了，上牙床肿了，嘴角气泡了..."];
    
    // 2016-11-7
    HappyTimeModel *activityData12 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData12 ActivityTime:@"2016-11-07" activityName:@"有盼头啦" activityDetailInfo:@"跟亲爱的聊天一提到以后，就显得遥遥无期。所以，今天决定了，12月2号要回北京看老婆。嘿嘿😜"];
    
    // 2016-11-6
    HappyTimeModel *activityData11 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData11 ActivityTime:@"2016-11-06" activityName:@"小伤心" activityDetailInfo:@"本打算去杭州找兄弟来着，但是离开北京之后还没有回去看老婆，就去看别人，能感觉到亲爱的略微的伤心，我错了..."];
    
    // 2016-11-5
    HappyTimeModel *activityData10 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData10 ActivityTime:@"2016-11-05" activityName:@"太污啦" activityDetailInfo:@"亲爱的，太污啦，跟我聊一些少儿不宜的东西，憋死我啦。哼~"];
    
    // 2016-11-4
    HappyTimeModel *activityData9 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData9 ActivityTime:@"2016-11-04" activityName:@"发工资啦" activityDetailInfo:@"发工资啦，发工资啦，1W大洋，爽死啦😄😄"];
    
    // 2016-11-3
    HappyTimeModel *activityData8 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData8 ActivityTime:@"2016-11-03" activityName:@"第一叫老公、老婆" activityDetailInfo:@"“处个对象，连老公都不让叫”\n“亲爱的，你懂我的。”\n“那你求求我，我再叫😝😝”\n“亲爱的老婆大人，叫我一声老公吧，求求你了。🤕🤕”\n“嘿嘿，叫完你老公，你就要有老公的样子，知道不？”\n“恩呢，罪臣知道了。”\n“亲爱的老公，我爱你。😘😘”\n“亲爱的老婆，老公爱你！😘😘”..."];
    
    // 2016-11-2
    HappyTimeModel *activityData7 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData7 ActivityTime:@"2016-11-02" activityName:@"第一次视频" activityDetailInfo:@"一周多没见亲爱的了，第一次视频，羞羞哒..."];
    
    // 2016-11-1
    HappyTimeModel *activityData6 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData6 ActivityTime:@"2016-11-01" activityName:@"爱心大礼包" activityDetailInfo:@"给亲爱的买的爱心大礼包，有玫瑰、有贺卡..."];
    
    // 2016-10-31
    HappyTimeModel *activityData5 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData5 ActivityTime:@"2016-10-31" activityName:@"等我来娶你" activityDetailInfo:@"小v：我等你来娶我好么，非你不嫁！"];
    
    // 2016-10-27
    HappyTimeModel *activityData4 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData4 ActivityTime:@"2016-10-27" activityName:@"第一次分开" activityDetailInfo:@"刚刚恋爱，第二天就异地，哎、伤心💔..."];
    
    // 2016-10-26
    HappyTimeModel *activityData3 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData3 ActivityTime:@"2016-10-26" activityName:@"第一次接吻" activityDetailInfo:@"恋爱的第一天我们就接吻了，很快、很甜蜜..."];
    
    // 2016-10-26
    HappyTimeModel *activityData2 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData2 ActivityTime:@"2016-10-26" activityName:@"爱情纪念日" activityDetailInfo:@"这是一个值得纪念的日子，这一天我们在一起啦、幸福ing~"];
    
    // 2016-10-25
    HappyTimeModel *activityData1 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData1 ActivityTime:@"2016-10-25" activityName:@"第一次约会" activityDetailInfo:@"第一次跟小v约会，讲了SVN、讲了Git，我们去了后海，送小v回家..."];
    
    // 2016-10-23
    HappyTimeModel *activityData0 = [[HappyTimeModel alloc] init];
    [self loadActivityData:activityData0 ActivityTime:@"2016-10-23" activityName:@"第一次相遇" activityDetailInfo:@"这是我们第一次相遇的日子，感谢义哥，感谢阡陌！"];
    
    self.happinessTimeTableVC.dataArray = [@[activityData25, activityData24, activityData23, activityData22, activityData21, activityData20, activityData19, activityData18, activityData17, activityData16, activityData15, activityData14, activityData13, activityData12, activityData11, activityData10, activityData9, activityData8, activityData7, activityData6, activityData5, activityData4, activityData3, activityData2, activityData1, activityData0] mutableCopy];
}


#pragma mark - 首页加载幸福时光数据封装
- (void)loadActivityData:(HappyTimeModel *)happyData ActivityTime:(NSString *)activityTime activityName:(NSString *)activityName activityDetailInfo:(NSString *)activityDetailInfo {
    
    happyData.time = activityTime;
    happyData.titleName = activityName;
    happyData.detailInfo = activityDetailInfo;
    
    // 布局计算
    CGFloat height = 85;
    CGSize activityNameSize = [QMUtil sizeWithString:happyData.titleName font:XiHeiFont(16) size:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX)];
    if(activityNameSize.height > 20) {
        height += (activityNameSize.height - 20);
    }
    CGSize activityDetailSize = [QMUtil sizeWithString:happyData.detailInfo font:XiHeiFont(16) size:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX)];
    height += activityDetailSize.height;
    
    happyData.contentHeight = height;
}

#pragma mark - ANTBaseTableViewControllerDelegate
- (void)pullNextPageRequest:(UITableView *)tableView {
    [MBProgressHUD showTip:@"么么哒~"];
}

- (void)pullRefreshRequest:(UITableView *)tableView {
    [MBProgressHUD showTip:@"么么哒~"];
    [self.happinessTimeTableVC loadDataFail];
}

#pragma mark - 创建波浪
- (void)addWaveProgressView {
    TYWaveProgressView *waveProgressView = [[TYWaveProgressView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 10, kScreenWidth, 60)];
    waveProgressView.waveViewMargin = UIEdgeInsetsMake(0, 0, 49, 0);
    waveProgressView.numberLabel.text = @"5%";
    waveProgressView.numberLabel.font = [UIFont boldSystemFontOfSize:1];
    waveProgressView.numberLabel.textColor = [UIColor whiteColor];
    waveProgressView.waterWaveView.firstWaveColor = [UIColor colorWithRed:254.0/255.0f green:64.0f/255.0f blue:61.0/255.0f alpha:0.15];
    waveProgressView.waterWaveView.secondWaveColor = [UIColor colorWithRed:254.0/255.0f green:64.0f/255.0f blue:61.0/255.0f alpha:0.15];
    waveProgressView.percent = 0.10;
    [self.view addSubview:waveProgressView];
    _waveProgressView1 = waveProgressView;
    [_waveProgressView1 startWave];
}

- (HappinessTimeTableViewController *)happinessTimeTableVC {
    if (!_happinessTimeTableVC) {
        _happinessTimeTableVC = [[HappinessTimeTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _happinessTimeTableVC.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _happinessTimeTableVC.delegate = (id)self;
        _happinessTimeTableVC.enableRefresh = YES;
        _happinessTimeTableVC.enableNextPage = YES;
        _happinessTimeTableVC.view.backgroundColor = [UIColor clearColor];
    }
    return _happinessTimeTableVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

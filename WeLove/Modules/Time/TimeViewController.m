//
//  TimeViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/3.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "TimeViewController.h"

#import "FFMemberCenterHeadView.h"              // 头部视图
#import "HappinessTimeTableViewController.h"    // 幸福时光
#import "MTToViewTopButton.h"                   // 回到顶部
#import "TYWaveProgressView.h"  // 波浪

@interface TimeViewController ()

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

@implementation TimeViewController

- (void)loadSubViews {
    [super loadSubViews];
    self.titleLabel.text = @"时光";
    
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.happinessTimeTableVC.view];
}

- (void)layoutConstraints {
    
    /***************************恋爱时间*****************************/
    self.headView = [[FFMemberCenterHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    
    // 计算在一起时间
    NSString *beginTime = [self getUTCFormateDate:@"2016-10-26 05:20"];
    // 倒计时还有多少天见面
//    NSString *jianTime = [self getUTCFormateDate:@"2016-12-02 00:00"];
    
    [self.headView startIntegralAnimationWithMaxLevel:11 UserIntegral:[beginTime floatValue] UserLevel:7 UserlevelIntegral:0 nextLevelIntegral:36 userNickName:@"" ActiveSize:CGSizeMake(180, 75) NormalSize:CGSizeMake(30, 35)];
    
    /***************************恋爱时光*****************************/
    WS(weakSelf);
    [self.happinessTimeTableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 49, 0));
    }];
    self.happinessTimeTableVC.tableView.tableHeaderView = self.headView;
    
    /***************************回到顶部*****************************/
    MTToViewTopButton *topButton = [[MTToViewTopButton alloc] initWithFrame:CGRectZero scrollView:(UIScrollView *)self.happinessTimeTableVC.view];
    topButton.showBtnOffset = 350;
    [self.view addSubview:topButton];
    
    /***************************波   浪*****************************/
    [self addWaveProgressView];
}

#pragma mark - 首页加载幸福时光数据封装
- (void)loadActivityData:(HappyTimeModel *)activityData ActivityTime:(NSString *)activityTime activityName:(NSString *)activityName activityDetailInfo:(NSString *)activityDetailInfo imageData:(QMImageModel *)imageData imageUrl1:(NSString *)imageUrl1 imageUrl2:(NSString *)imageUrl2 imageUrl3:(NSString *)imageUrl3 {
    
    activityData.activityTime = activityTime;
    activityData.activityName = activityName;
    activityData.activityDetailInfo = activityDetailInfo;
    
    imageData.imageUrl = imageUrl1;
    imageData.imageUrl2 = imageUrl2;
    imageData.imageUrl3 = imageUrl3;
    
    activityData.pictureArray = @[imageData,imageData,imageData];
    
    // 布局计算
    CGFloat height = 85;
    CGSize activityNameSize = [QMUtil sizeWithString:activityData.activityName font:XiHeiFont(16) size:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX)];
    if(activityNameSize.height>20)
    {
        height += (activityNameSize.height-20);
    }
    CGSize activityDetailSize = [QMUtil sizeWithString:activityData.activityDetailInfo font:XiHeiFont(16) size:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX)];
    height += activityDetailSize.height;
    if (activityData.pictureArray.count) {
        CGFloat itemHeight = (kScreenWidth-100-20)/3;
        if (activityData.pictureArray.count%3==0) {
            height += (activityData.pictureArray.count/3-1)*10 + (activityData.pictureArray.count/3)*itemHeight;
        } else {
            height += activityData.pictureArray.count/3*10 + (activityData.pictureArray.count/3+1)*itemHeight;
        }
        height += 15;
    }
    activityData.contentHeight = height;
}

#pragma mark - 加载3D球数据
- (void)loadData {
    
    /*
     NSArray *tmpArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeDatasList" ofType:@"plist"]];
     
     for (NSDictionary *dict in tmpArr) {
     
     FarmActivityModel *activityData = [FarmActivityModel homeModelWithDict:dict];
     QMImageModel *imageData = [[QMImageModel alloc] init];
     [self.happinessTimeTableVC.dataArray addObject:activityData];
     
     [self loadActivityData:activityData ActivityTime:dict[@"time"] activityName:dict[@"title"] activityDetailInfo:dict[@"info"] imageData:imageData imageUrl:dict[@"images"]];
     
     self.happinessTimeTableVC.dataArray = [@[activityData] mutableCopy];
     }
     
     NSLog(@"%@",tmpArr);
     */
    
    
    
    
    // 2016-11-9
    HappyTimeModel *activityData14 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData14 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData14 ActivityTime:@"2016-11-09" activityName:@"来自远方的关心" activityDetailInfo:@"亲爱的让我好好吃饭，有精力了才能赚钱给媳妇花~" imageData:imageData14 imageUrl1:nil imageUrl2:nil imageUrl3:nil];
    
    // 2016-11-8
    HappyTimeModel *activityData13 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData13 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData13 ActivityTime:@"2016-11-08" activityName:@"换卧室啦" activityDetailInfo:@"换小卧室啦，亲爱的上火了，上牙床肿了，嘴角气泡了..." imageData:imageData13 imageUrl1:nil imageUrl2:nil imageUrl3:nil];
    
    // 2016-11-7
    HappyTimeModel *activityData12 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData12 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData12 ActivityTime:@"2016-11-07" activityName:@"有盼头啦" activityDetailInfo:@"跟亲爱的聊天一提到以后，就显得遥遥无期。所以，今天决定了，12月2号要回北京看老婆。嘿嘿😜" imageData:imageData12 imageUrl1:nil imageUrl2:nil imageUrl3:nil];
    
    // 2016-11-6
    HappyTimeModel *activityData11 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData11 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData11 ActivityTime:@"2016-11-06" activityName:@"小伤心" activityDetailInfo:@"本打算去杭州找兄弟来着，但是离开北京之后还没有回去看老婆，就去看别人，能感觉到亲爱的略微的伤心，我错了..." imageData:imageData11 imageUrl1:nil imageUrl2:nil imageUrl3:nil];
    
    // 2016-11-5
    HappyTimeModel *activityData10 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData10 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData10 ActivityTime:@"2016-11-05" activityName:@"太污啦" activityDetailInfo:@"亲爱的，太污啦，跟我聊一些少儿不宜的东西，憋死我啦。哼~" imageData:imageData10 imageUrl1:nil imageUrl2:nil imageUrl3:nil];
    
    // 2016-11-4
    HappyTimeModel *activityData9 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData9 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData9 ActivityTime:@"2016-11-04" activityName:@"发工资啦" activityDetailInfo:@"发工资啦，发工资啦，1W大洋，爽死啦😄😄" imageData:imageData9 imageUrl1:nil imageUrl2:nil imageUrl3:nil];
    
    // 2016-11-3
    HappyTimeModel *activityData8 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData8 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData8 ActivityTime:@"2016-11-03" activityName:@"第一叫老公、老婆" activityDetailInfo:@"“处个对象，连老公都不让叫”\n“亲爱的，你懂我的。”\n“那你求求我，我再叫😝😝”\n“亲爱的老婆大人，叫我一声老公吧，求求你了。🤕🤕”\n“嘿嘿，叫完你老公，你就要有老公的样子，知道不？”\n“恩呢，罪臣知道了。”\n“亲爱的老公，我爱你。😘😘”\n“亲爱的老婆，老公爱你！😘😘”..." imageData:imageData8 imageUrl1:@"http://a2.qpic.cn/psb?/V10xIXyj3VXuB8/G2vcutszvLKnGCrKinkHLvTqr812zKtQYlPoHpQpKB0!/m/dAkBAAAAAAAAnull&bo=7gI2Be4CNgUDCSw!&rf=photolist&t=5" imageUrl2:nil
                 imageUrl3:nil];
    
    // 2016-11-2
    HappyTimeModel *activityData7 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData7 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData7 ActivityTime:@"2016-11-02" activityName:@"第一次视频" activityDetailInfo:@"一周多没见亲爱的了，第一次视频，羞羞哒..." imageData:imageData7 imageUrl1:@"http://a1.qpic.cn/psb?/V10xIXyj3VXuB8/1k90UUuJD9AR0V0ECZIur8GIje0VUG9y*g8JxQFQknU!/m/dNwAAAAAAAAAnull&bo=OASgBdALwA8FCac!&rf=photolist&t=5"
                 imageUrl2:@"http://a1.qpic.cn/psb?/V10xIXyj3VXuB8/1k90UUuJD9AR0V0ECZIur8GIje0VUG9y*g8JxQFQknU!/m/dNwAAAAAAAAAnull&bo=OASgBdALwA8FCac!&rf=photolist&t=5"
                 imageUrl3:@"http://a1.qpic.cn/psb?/V10xIXyj3VXuB8/1k90UUuJD9AR0V0ECZIur8GIje0VUG9y*g8JxQFQknU!/m/dNwAAAAAAAAAnull&bo=OASgBdALwA8FCac!&rf=photolist&t=5"];
    
    // 2016-11-1
    HappyTimeModel *activityData6 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData6 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData6 ActivityTime:@"2016-11-01" activityName:@"爱心大礼包" activityDetailInfo:@"给亲爱的买的爱心大礼包，有玫瑰、有贺卡..." imageData:imageData6 imageUrl1:@"http://a2.qpic.cn/psb?/V10xIXyj3VXuB8/rdeEAw95EBaGh*Tc8EbG.5Vzh6U4v*7JZTDQCqLYUIw!/m/dHEBAAAAAAAAnull&bo=wAMABcADAAUFCSo!&rf=photolist&t=5"
                 imageUrl2:@"http://a2.qpic.cn/psb?/V10xIXyj3VXuB8/2yjH5qRDbMzsZjDq2n4Wdk2TAIzpNvTh3bhtHPfXspw!/m/dHEBAAAAAAAAnull&bo=wAMABcADAAUFCSo!&rf=photolist&t=5"
                 imageUrl3:@"http://a2.qpic.cn/psb?/V10xIXyj3VXuB8/mtmncYM3GNq*PQXPaMta2c1xVfYHwUAuWk9kl7hvpuQ!/m/dAkBAAAAAAAAnull&bo=wAMABcADAAUFCSo!&rf=photolist&t=5"];
    
    // 2016-10-31
    HappyTimeModel *activityData5 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData5 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData5 ActivityTime:@"2016-10-31" activityName:@"等我来娶你" activityDetailInfo:@"小v：我等你来娶我好么，非你不嫁！" imageData:imageData5 imageUrl1:@"http://a2.qpic.cn/psb?/V10xIXyj3VXuB8/U3Ao7PeKz06laepJvcaryuZHKa4oOGnjCxVLO84mUwU!/m/dAkBAAAAAAAAnull&bo=7gI2Be4CNgUDCSw!&rf=photolist&t=5" imageUrl2:nil
                 imageUrl3:nil];
    
    // 2016-10-27
    HappyTimeModel *activityData4 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData4 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData4 ActivityTime:@"2016-10-27" activityName:@"第一次分开" activityDetailInfo:@"刚刚恋爱，第二天就异地，哎、伤心💔..." imageData:imageData4 imageUrl1:@"http://a3.qpic.cn/psb?/V10xIXyj3VXuB8/NcopJJLpvjvMuC5qLyb168LI9VHmU2wtDxocKwvhUOI!/m/dAoBAAAAAAAAnull&bo=IANYAiADWAIFCSo!&rf=photolist&t=5" imageUrl2:nil
                 imageUrl3:nil];
    
    // 2016-10-26
    HappyTimeModel *activityData3 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData3 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData3 ActivityTime:@"2016-10-26" activityName:@"第一次接吻" activityDetailInfo:@"恋爱的第一天我们就接吻了，很快、很甜蜜..." imageData:imageData3 imageUrl1:@"http://a1.qpic.cn/psb?/V10xIXyj3VXuB8/Q1daAD0shpzbck7sKGbcBrsQP6vWyHMe2lZpfM.Hzs0!/m/dNwAAAAAAAAAnull&bo=gAJVA4ACVQMFCSo!&rf=photolist&t=5" imageUrl2:nil
                 imageUrl3:nil];
    
    // 2016-10-26
    HappyTimeModel *activityData2 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData2 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData2 ActivityTime:@"2016-10-26" activityName:@"爱情纪念日" activityDetailInfo:@"这是一个值得纪念的日子，这一天我们在一起啦、幸福ing~" imageData:imageData2
                 imageUrl1:@"http://a3.qpic.cn/psb?/V10xIXyj3VXuB8/nt1VTh1txTb2uPIr7KAANqztA1o.JMQveJHs27ltdDs!/m/dAoBAAAAAAAAnull&bo=7gI2Be4CNgUDCSw!&rf=photolist&t=5"
                 imageUrl2:@"http://a4.qpic.cn/psb?/V10xIXyj3VXuB8/QSdegLfRrymjlc91WPtmsAfZIWB3jRXSVcrJBxD.XLg!/m/dHcBAAAAAAAAnull&bo=7gI2Be4CNgUDCSw!&rf=photolist&t=5"
                 imageUrl3:@"http://a2.qpic.cn/psb?/V10xIXyj3VXuB8/fkwgu1a20fgT89x578TCfSaoG9*XL*uZxMv5IXxpr*4!/m/dHEBAAAAAAAAnull&bo=7gI2Be4CNgUDCSw!&rf=photolist&t=5"];
    
    // 2016-10-25
    HappyTimeModel *activityData1 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData1 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData1 ActivityTime:@"2016-10-25" activityName:@"第一次约会" activityDetailInfo:@"第一次跟小v约会，讲了SVN、讲了Git，我们去了后海，送小v回家..." imageData:imageData1 imageUrl1:@"http://a1.qpic.cn/psb?/V10xIXyj3VXuB8/Q1daAD0shpzbck7sKGbcBrsQP6vWyHMe2lZpfM.Hzs0!/m/dNwAAAAAAAAAnull&bo=gAJVA4ACVQMFCSo!&rf=photolist&t=5" imageUrl2:nil
                 imageUrl3:nil];
    
    // 2016-10-23
    HappyTimeModel *activityData0 = [[HappyTimeModel alloc] init];
    QMImageModel *imageData0 = [[QMImageModel alloc] init];
    [self loadActivityData:activityData0 ActivityTime:@"2016-10-23" activityName:@"第一次相遇" activityDetailInfo:@"这是我们第一次相遇的日子，感谢义哥，感谢阡陌！" imageData:imageData0
                 imageUrl1:@"http://a2.qpic.cn/psb?/V10xIXyj3VXuB8/BSgEAx714JqT6OlgKV6UjETe7BmrHHlru426AXdU7QQ!/m/dAkBAAAAAAAAnull&bo=IgIgAyICIAMFCSo!&rf=photolist&t=5"
                 imageUrl2:@"http://a3.qpic.cn/psb?/V10xIXyj3VXuB8/oxKD1tU*jUsiOK9S6azrfEN18hapx0j0ZR*h7cqa9Eg!/m/dAoBAAAAAAAAnull&bo=4wKHA.MChwMFCSo!&rf=photolist&t=5"
                 imageUrl3:nil];
    
    self.happinessTimeTableVC.dataArray = [@[activityData14, activityData13, activityData12, activityData11, activityData10, activityData9, activityData8, activityData7, activityData6, activityData5, activityData4, activityData3, activityData2, activityData1, activityData0] mutableCopy];
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
    TYWaveProgressView *waveProgressView = [[TYWaveProgressView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 60, kScreenWidth, 60)];
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


#pragma mark - 计时器，获取天数
- (NSString *)getUTCFormateDate:(NSString *)newsDate {
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSLog(@"newsDate = %@",newsDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time = [current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month = ((int)time) / (3600*24*30);
    int days = ((int)time) / (3600*24);
    int hours = ((int)time) % (3600*24)/3600;
    int minute = ((int)time) % (3600*24)/60;
    
    NSLog(@"time=%f",(double)time);
    
    NSString *dateContent;
    
    
    if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",month,@"个月前"];
        
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%i",days];
        self.dateContent = dateContent;
        NSLog(@"%@",dateContent);
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",hours,@"小时前"];
    }else {
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",minute,@"分钟前"];
    }
    
    //    NSString *dateContent = [[NSString alloc] initWithFormat:@"%i天",days];
    
    
    return dateContent;
}

- (HappinessTimeTableViewController *)happinessTimeTableVC {
    if (!_happinessTimeTableVC) {
        _happinessTimeTableVC = [[HappinessTimeTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _happinessTimeTableVC.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _happinessTimeTableVC.delegate = (id)self;
        _happinessTimeTableVC.enableRefresh = YES;
        _happinessTimeTableVC.enableNextPage = YES;
    }
    return _happinessTimeTableVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

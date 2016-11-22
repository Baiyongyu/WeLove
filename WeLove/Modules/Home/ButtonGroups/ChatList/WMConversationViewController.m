



//
//  WMConversationViewController.m
//  RCIM
//
//  Created by 郑文明 on 15/12/30.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "WMConversationViewController.h"
#import "WMVideoMessage.h"
#import "WMVideoMessageCell.h"
/*!
 消息Cell点击的回调  RCMessageCellDelegate（我们要点击cell，播放视频，所以要遵守这个代理，然后实现点击cell的方法）
 */
@interface WMConversationViewController ()<RCMessageCellDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation WMConversationViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    view.backgroundColor = kNavColor;
    [self.view addSubview:view];
    
    [self backButton];
    [self navigationTitle];
    
    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    
    self.conversationMessageCollectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeBg"]];
    
    
    
    //在功能面板上插入一个Item，用来发送视频，并标记tag，方便区分
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"add_ico"]
                                        title:@"发送视频"
                                          tag:201];
    
    ///注册自定义视频消息Cell
    [self registerClass:[WMVideoMessageCell class] forCellWithReuseIdentifier:@"WMVideoMessageCell"];
}

- (void)backButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 25, 50, 30);
    [backButton setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
}

- (void)navigationTitle {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/2, 20, 80, 40)];
    _titleLabel.text = @"么么哒";
    _titleLabel.font = XiHeiFont(18);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
}

- (void)leftBarButtonItemPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//功能面板点击事件的方法，通过tag区分点击到的哪个item
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case 201:
        {
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];//记得调用super父类的方法
            NSLog(@"shipin");
            //初始化一个视频消息，传进去参数conten，为一个视频的url
            WMVideoMessage *videoMessage=[WMVideoMessage messageWithContent:@"http://admin.weixin.ihk.cn/ihkwx_upload/test.mp4"];
            //发送消息
            [self sendMessage:videoMessage pushContent:nil];
        }
            break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            NSLog(@"%ld",(long)pluginBoardView.tag);
            break;
    }
}
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    if (!self.displayUserNameInCell) {
        if (model.messageDirection == MessageDirection_RECEIVE) {
            model.isDisplayNickname = NO;
        }
    }
    RCMessageContent *messageContent = model.content;
    
    if ([messageContent isMemberOfClass:[WMVideoMessage class]])
    {
        WMVideoMessageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"WMVideoMessageCell" forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    }
    else {
        return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    }   else if ([messageContent isMemberOfClass:[WMVideoMessage class]])
    {
        return CGSizeMake(collectionView.frame.size.width, 140);
    }
    else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end


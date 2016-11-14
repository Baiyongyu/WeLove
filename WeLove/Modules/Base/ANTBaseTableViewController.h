//
//  ANZBaseTableViewController.h
//  anz
//
//  Created by KevinCao on 16/6/28.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ANTBaseTableViewControllerDelegate <NSObject>
@optional
/**
 *  上拉加载下一页
 *
 *  @param tableView
 */
- (void)pullNextPageRequest:(UITableView *)tableView;
/**
 *  下拉刷新
 *
 *  @param tableView
 */
- (void)pullRefreshRequest:(UITableView *)tableView;
@end

@interface ANTBaseTableViewController : UITableViewController
@property(nonatomic,weak)id<ANTBaseTableViewControllerDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic, assign)int pageNum;        //当前页码
@property(nonatomic, assign)int totalPagesNum;  //总页码
@property(nonatomic,assign)BOOL enableRefresh;  //是否有下拉刷新功能
@property(nonatomic,assign)BOOL enableNextPage; //是否有上拉请求功能
@property(nonatomic,copy)NSString *noDataTip;   //无数据时的提示信息

/**
 *  加载数据成功
 *
 *  @param responseArray 获取的数据
 */
- (void)loadDataSuccess:(NSArray *)responseArray;
/**
 *  加载数据失败
 */
- (void)loadDataFail;

@end

typedef enum
{
    ArrowsSate_Normal=0,
    ArrowsSate_Ready,
    ArrowsSate_Start,
    ArrowsSate_End,
    ArrowsSate_LastPage,
    ArrowsSate_Hiden=0,
}ArrowsSate;

typedef enum
{
    ArrowsType_Refresh=0,
    ArrowsType_Request,
}ArrowsType;

@class ArrowView;
@protocol DOArrowViewProtocol <NSObject>
- (void)arrowView:(ArrowView*)view state:(ArrowsSate)state;
@end
@interface ArrowView : UIView
@property(nonatomic,assign,setter=setState:)ArrowsSate state;
@property(nonatomic,copy,setter=setText:)NSString* text;
@property(nonatomic,assign)ArrowsType type;
@property(nonatomic,weak)id<DOArrowViewProtocol> delegate;
@end

//
//  FFBarrageManager.m
//  FFBarrageDemo
//
//  Created by Fan on 16/10/31.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import "FFBarrageManager.h"
#import "FFBarrageView.h"

#define kDefaultTrajectoryCount 3   ///< 默认弹幕轨道数
//#define kDefaultTrjectoryPadding   10.0     ///< 默认弹幕

@interface FFBarrageManager ()
@property(nonatomic, strong) NSMutableArray *datasource;    ///< 弹幕的数据来源

@property(nonatomic, strong) NSMutableArray *barrageComments;   ///< 使用过程中的数组变量

@property(nonatomic, strong) NSMutableArray *barrageViews;      ///< 存储弹幕view的数组变量

@property(nonatomic, assign) BOOL isBarrageStart;           ///< 判断当前弹幕的状态
@end

@implementation FFBarrageManager

- (instancetype)initWithComments:(NSArray *)comments
{
    if (self = [super init]) {
        _isBarrageStart = NO;
        
        [self.datasource addObjectsFromArray:comments];
        _trajectoryCount = kDefaultTrajectoryCount;
    }
    return self;
}

- (void)initBarrageComment
{
    NSMutableArray *trajectorys = [NSMutableArray array];
    for (int i=0; i<self.trajectoryCount; i++) {
        [trajectorys addObject:@(i)];
    }
    
    for (int i=0; i<self.trajectoryCount; i++) {
        NSInteger index = arc4random()%trajectorys.count;
        int trajectory = [[trajectorys objectAtIndex:index] intValue];
        [trajectorys removeObjectAtIndex:index];
        
        NSString *comments = [self.barrageComments firstObject];
        [self.barrageComments removeObjectAtIndex:0];
        
        [self createBarrageView:comments trajectory:trajectory];
    }
}

- (void)createBarrageView:(NSString *)comment trajectory:(int)trajectory
{
    if (!self.isBarrageStart) {
        return;
    }
    
    FFBarrageView *view = [[FFBarrageView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    
    __weak typeof (view) weakView = view;
    __weak typeof (self) weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (!self.isBarrageStart) {
            return ;
        }
        
        switch (status) {
            case Start: {
                //弹幕开始进入屏幕，将弹幕view加入到弹幕管理变量中的barrageViews中
                [weakSelf.barrageViews addObject:weakView];
                break;
            }
            case Enter: {
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有，则在弹幕轨迹中创建弹幕
                NSString *newComment = [self nextComment];
                if (newComment) {
                    [weakSelf createBarrageView:newComment trajectory:trajectory];
                }
                break;
            }
            case End: {
                //弹幕完全飞出屏幕后，从barrageViews释放资源
                if ([weakSelf.barrageViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.barrageViews removeObject:weakView];
                }
                
                //说明屏幕上已经没有弹幕，开始循环滚动
                if (weakSelf.barrageViews.count == 0) {
                    self.isBarrageStart = NO;
                    [weakSelf start];
                }
                
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextComment
{
    if (self.barrageComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.barrageComments firstObject];
    if (comment) {
        [self.barrageComments removeObjectAtIndex:0];
    }
    return comment;
}

- (void)start
{
    if (self.isBarrageStart) {
        return;
    }
    
    
    self.isBarrageStart = YES;
    [self.barrageComments removeAllObjects];
    [self.barrageComments addObjectsFromArray:self.datasource];
    
    [self initBarrageComment];
}

- (void)stop
{
    if (!self.isBarrageStart) {
        return;
    }
    
    self.isBarrageStart = NO;
    [self.barrageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FFBarrageView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    
    [self.barrageViews removeAllObjects];
}

- (void)appendData:(NSArray *)data
{
    [self.datasource addObjectsFromArray:data];
    [self.barrageComments addObjectsFromArray:data];
}

#pragma mark - setter
- (void)setTrajectoryCount:(NSInteger)trajectoryCount
{
    _trajectoryCount = trajectoryCount;
}

#pragma mark - getter
- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSMutableArray *)barrageComments{
    if (!_barrageComments) {
        _barrageComments = [NSMutableArray array];
    }
    return _barrageComments;
}

- (NSMutableArray *)barrageViews{
    if (!_barrageViews) {
        _barrageViews = [NSMutableArray array];
    }
    return _barrageViews;
}
@end

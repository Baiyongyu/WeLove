//
//  MusicListViewController.m
//  WeLove
//
//  Created by 宇玄丶 on 2016/11/16.
//  Copyright © 2016年 anqianmo. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicModel.h"
#import "MusicTableViewCell.h"
#import "AudioPlayerController.h"

@interface MusicListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *songTableView;
@property (nonatomic, strong) NSMutableArray *songArray;

@end


@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"音乐列表";
    self.leftBtn.hidden = NO;
    [self creatTableView];
    [self dataJson];
}

- (void)dataJson {
    NSString *str = [[NSBundle mainBundle]pathForResource:@"musicPaper" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:str];
    
    NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@,  ---%ld",dataArray, dataArray.count);
    for (NSDictionary *dic in dataArray) {
        MusicModel *model = [[MusicModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.songArray addObject:model];
    }
    [self.songTableView reloadData];
}

- (void)creatTableView {
    self.songTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
//    _songTableView.backgroundColor = [UIColor clearColor];
    _songTableView.delegate = self;
    _songTableView.dataSource = self;
    _songTableView.separatorColor = kNavColor;
    _songTableView.tableFooterView = [UIView new];
    //    _songTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.songTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
 
    MusicModel *model = [[MusicModel alloc] init];
    model = [self.songArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@_%@", model.name, model.singer];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AudioPlayerController *audio = [AudioPlayerController audioPlayerController];
    [audio initWithArray:self.songArray index:indexPath.row];
    [self presentViewController:audio animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (NSMutableArray *)songArray {
    if (!_songArray) {
        _songArray = [NSMutableArray array];
    }
    return _songArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ReplayMineViewController.m
//  acgn
//
//  Created by Ares on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ReplayMineViewController.h"
#import "MsgTableViewCell.h"

@interface ReplayMineViewController ()<UITableViewDelegate, UITableViewDataSource, EmptyViewDelegate>
@property (nonatomic, strong) UITableView *rTableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSString *lastID;
@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation ReplayMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.lastID = @"-1";
    self.datas = [NSMutableArray array];
    [self.view addSubview:self.emptyView];
    [self.view addSubview:self.rTableView];
    [self addRefreshLoadMore:self.rTableView];
}

- (void)addRefreshLoadMore:(UITableView *)tableView {
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [tableView.mj_header beginRefreshing];
}

- (void)endRefreshing:(UITableView *)tableView {
    [tableView.mj_footer endRefreshing];
    [tableView.mj_header endRefreshing];
}

- (void)refresh {
    self.lastID = @"-1";
    [self getReplayMineMsg];
}

- (void)loadMore {
    [self getReplayMineMsg];
}

- (void)getReplayMineMsg {
    WS(weakSelf);
    [AApiModel replyMeList:self.lastID block:^(BOOL result, NSArray *array) {
        if (result) {
            if (array.count > 0) {
                weakSelf.rTableView.hidden = NO;
                weakSelf.emptyView.hidden = YES;
                if (self.lastID.intValue == -1) {
                    [weakSelf.datas removeAllObjects];
                }
                [weakSelf.datas addObjectsFromArray:array];
                DynamicCommentListData *data = [weakSelf.datas lastObject];
                weakSelf.lastID = data.commentId;
            }else {
                if (self.lastID.intValue == -1 && weakSelf.datas.count ==0) {
                    weakSelf.emptyView.hidden = NO;
                    weakSelf.rTableView.hidden = YES;
                }
            }
            [weakSelf.rTableView reloadData];
        }
        [weakSelf endRefreshing:weakSelf.rTableView];
    }];
}

- (CGFloat)getCellMaxHeight:(NSIndexPath *)indexPath {
    DynamicCommentListData *dynamicObj = [self.datas objectAtIndex:indexPath.row];
    CGFloat H = [MsgTableViewCell getCellMaxHeightAndUpdate:dynamicObj];
    return H;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.datas.count) {
        CGFloat H = [self getCellMaxHeight:indexPath];
        return H;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MsgCell = @"MsgTableViewCell";
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MsgCell];
    if (!cell) {
        cell = [[MsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MsgCell];
    }
    
    if (self.datas.count > 0) {
        DynamicCommentListData *data = [self.datas objectAtIndex:indexPath.row];
        [cell configDynamicObj:data];
    }
    
    return cell;
}
#pragma mark - 初始化UIKIT
- (UITableView *)rTableView {
    if (!_rTableView) {
        _rTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  [ATools setViewFrameHeightToBottomForIPhoneX:DMScreenHeight-[ATools setViewFrameYForIPhoneX:107]] ) style:UITableViewStylePlain];
        _rTableView.delegate = self;
        _rTableView.dataSource = self;
        _rTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rTableView.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
        //_rTableView.tableHeaderView = self.headerView;
    }
    return _rTableView;
}
- (EmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [ATools setViewFrameHeightToBottomForIPhoneX:DMScreenHeight-[ATools setViewFrameYForIPhoneX:107]]) delegate:self];
        _emptyView.backgroundColor = [UIColor whiteColor];
        [_emptyView updateInfo:@"comment_null" title:@"你可以更犀利一些，让大家知道你" btnTitle:@""];
        self.emptyView.hidden = YES;
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

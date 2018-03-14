//
//  PeopleDetailsViewController.m
//  acgn
//
//  Created by lijian on 2018/2/11.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "PeopleDetailsViewController.h"
#import "PeopleDetailCell.h"
#import "PeopleDetailHeader.h"
#import "ModelShowViewController.h"
#import "Mode3DViewController.h"
#import "DMTransitioningAnimationHelper.h"
@interface PeopleDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, PeopleDetailHeaderDelegate, PeopleDetailCellDelegate>
@property (nonatomic, strong) UITableView *pTableView;
@property (nonatomic, strong) PeopleDetailHeader *headerView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) RoleDetailsDataModel *detailData;
@property (nonatomic, strong) NSString *lastID;
@property (nonatomic, strong) UIView *tempNavBar;
@property (strong, nonatomic) DMTransitioningAnimationHelper *animationHelper;
@end

@implementation PeopleDetailsViewController
#define  NAV_H [ATools getNavViewFrameHeightForIPhone]
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人详情";
    self.lastID = @"-2";
    self.view.backgroundColor =[UIColor redColor];
    self.datas = [NSMutableArray array];
    self.detailData = [[RoleDetailsDataModel alloc] init];
    [self.view addSubview:self.pTableView];
    
    [self addRefreshLoadMore:self.pTableView];
    [self.view addSubview:self.tempNavBar];
    self.tempNavBar.alpha = 0;
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self setNavigationBarTransparence:YES titleColor:[UIColor blackColor]];
}

- (void)addRefreshLoadMore:(UITableView *)tableView {
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    //[tableView.mj_header beginRefreshing];
}

- (void)endRefreshing:(UITableView *)tableView {
    [tableView.mj_footer endRefreshing];
    [tableView.mj_header endRefreshing];
}

- (void)refresh {
    if (self.lastID.intValue == -2) {
        [self getPeopleInfoDetails];
    }
    self.lastID = @"-1";
    [self getRoleDetails];
}

- (void)loadMore {
    [self getRoleDetails];
}

- (void)getPeopleInfoDetails {
    WS(weakSelf);
    
    [AApiModel getRoleInfoData:self.roleID block:^(BOOL result, RoleDetailsDataModel *obj) {
        if (result) {
            weakSelf.detailData = obj;
            CGFloat headerHeight = [PeopleDetailHeader getViewTotalHeight:obj];
            weakSelf.headerView.frame = CGRectMake(0, 0, weakSelf.pTableView.frame.size.width, headerHeight+NAV_H);
            weakSelf.pTableView.tableHeaderView = weakSelf.headerView;
            [weakSelf.headerView configInfo:obj];
            
        }
    }];
}

- (void)getRoleDetails {
    WS(weakSelf);
    [AApiModel getRoleDtailsListData:self.roleID lastId:self.lastID block:^(BOOL result, NSArray *array) {
        if (result) {
            if (array.count > 0) {
                if (self.lastID.intValue == -1) {
                    [weakSelf.datas removeAllObjects];
                }
                [weakSelf.datas addObjectsFromArray:array];
                RoleDetailsPostData *data = [weakSelf.datas lastObject];
                weakSelf.lastID = data.postId;
            }
            [weakSelf.pTableView reloadData];
        }
        [weakSelf endRefreshing:weakSelf.pTableView];
    }];
}

- (void)clickClickAttBtn:(id)sender {
    
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    WS(weakSelf);
    __block RoleDetailsDataModel *data = (RoleDetailsDataModel *)sender;
    
    if (data.hasFollow.intValue > 0) {
        [AApiModel delFollowForUser:data.roleId block:^(BOOL result) {
            if (result) {
                [weakSelf.headerView updateAttBtn:NO];
            }
            
        }];
    } else {
        [AApiModel addFollowForUser:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:data.roleId.intValue]] block:^(BOOL result) {
            if (result) {
                [weakSelf.headerView updateAttBtn:YES];
            }
            
        }];
    }
    
}

- (void)userClickFabulousPraise:(id)sender {
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    WS(weakSelf);
    DynamicListData *data = (DynamicListData *)sender;
    if (data.localPraise) {
        [AApiModel delFabulousForUser:data.postId block:^(BOOL result, NSString *praiseNum) {
            if (result) {
                data.localPraise = NO;
                data.fabulousNum = praiseNum;//[NSString stringWithFormat:@"%d", data.praiseNum.intValue-1];
            }
            [weakSelf.pTableView reloadData];
        }];
        
    } else {
        [AApiModel addFabulousForUser:data.postId block:^(BOOL result, NSString *praiseNum) {
            if (result) {
                data.localPraise = YES;
                data.fabulousNum = praiseNum;//[NSString stringWithFormat:@"%d", data.praiseNum.intValue+1];
            }
            [weakSelf.pTableView reloadData];
        }];
        
    }
}

- (void)clickGotoModeShow:(id)sender {
//    self.detailData.showType = @"3";
    if (self.detailData.showType.integerValue == Model_Show_Type_3D) {
        
        Mode3DViewController *ms3d = [[Mode3DViewController alloc] init];
        DMTransitioningAnimationHelper *animationHelper = [DMTransitioningAnimationHelper new];
        self.animationHelper = animationHelper;
        animationHelper.animationType = DMTransitioningAnimationRight;
        animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
        ms3d.transitioningDelegate = animationHelper;
        ms3d.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:ms3d animated:YES completion:^{
            
        }];
    } else {
        ModelShowViewController *msVC = [[ModelShowViewController alloc] init];
        msVC.detailData = self.detailData;
        [self.navigationController pushViewController:msVC animated:YES];
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.datas.count) {
        RoleDetailsPostData *data = [self.datas objectAtIndex:indexPath.row];
        DynamicDetailsViewController *ddVC = [[DynamicDetailsViewController alloc] init];
        ddVC.postID = data.postId;
        [self.navigationController pushViewController:ddVC animated:YES];
    }
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.datas.count) {
        RoleDetailsPostData *data = [self.datas objectAtIndex:indexPath.row];
        CGFloat height = [PeopleDetailCell getPeopleDetailCellHeight:data];
        return height;
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
    static NSString *peopleDCell = @"peopleDCell";
    PeopleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:peopleDCell];
    if (!cell) {
        cell = [[PeopleDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:peopleDCell];
        cell.delegate = self;
    }
    
    if (self.datas.count > 0) {
        RoleDetailsPostData *data = [self.datas objectAtIndex:indexPath.row];
        [cell configInfo:data];
    }
    
    return cell;
}

- (void)userClickVideo:(Info_Type)type videoUrl:(NSString *)videoUrl {
    if (STR_IS_NIL(videoUrl)) {
        [ATools showSVProgressHudCustom:@"" title:@"视频资源不存在"];
    } else {
        if (type == Info_Type_Video) {
            MoviePlayerViewController *moviePlayerVC = [[MoviePlayerViewController alloc] init];
            moviePlayerVC.videoURL = [NSURL URLWithString:videoUrl];
            [self.navigationController pushViewController:moviePlayerVC animated:YES];
        } else if (type == Info_Type_Url_Video) {
            
        }
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0) {
        CGFloat alpha = MIN(1, 1-(120-offsetY)/(120));//计算透明度
        self.tempNavBar.alpha = alpha;
    } else {
        self.tempNavBar.alpha = 0;
    }
}


#pragma mark - 初始化UIKIT
- (UITableView *)pTableView {
    if (!_pTableView) {
        _pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, DMScreenHeight) style:UITableViewStylePlain];
        _pTableView.delegate = self;
        _pTableView.dataSource = self;
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pTableView.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
        //_pTableView.tableHeaderView = self.headerView;
        if (@available(iOS 11.0, *)) {
            _pTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.pTableView.estimatedRowHeight = 0;
        self.pTableView.estimatedSectionHeaderHeight = 0;
        self.pTableView.estimatedSectionFooterHeight = 0;
    }
    return _pTableView;
}

#pragma mark - 初始化UIKIT
- (PeopleDetailHeader *)headerView {
    if (!_headerView) {
        _headerView = [[PeopleDetailHeader alloc] init];
        _headerView.backgroundColor = [UIColor redColor];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)tempNavBar {
    if (!_tempNavBar) {
        _tempNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, [ATools getNavViewFrameHeightForIPhone])];
        _tempNavBar.backgroundColor = [UIColor whiteColor];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _tempNavBar.frame.size.height-0.5, _tempNavBar.frame.size.width, 0.5)];
        lineLabel.backgroundColor = UIColorFromRGB(0x939393);
        [_tempNavBar addSubview:lineLabel];
    }
    return _tempNavBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  AttentViewController.m
//  acgn
//
//  Created by lijian on 2018/2/5.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "AttentViewController.h"
#import "AttentionPeopleList.h"
#import "ContentListView.h"
@interface AttentViewController () <AttentionPeopleListDelegate, ContentListDelegate>
@property (nonatomic, strong) AttentionPeopleList *apListView;
@property (nonatomic, strong) ContentListView *contentListView;

@property (nonatomic, strong) NSString *lastPeopleID;
@property (nonatomic, strong) NSMutableArray *roleListDatas;
@property (nonatomic, strong) NSMutableArray *noFollowIDs;

@property (nonatomic, strong) NSString *lastID;
@property (nonatomic, strong) NSString *firstID;
@property (nonatomic, strong) NSMutableArray *attentListDatas;
@property (nonatomic, assign) BOOL isNotificationGetDynamicData;
@end

@implementation AttentViewController

- (void)notificationAll {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfo:)
                                                 name:DMNotification_Login_Success_Key
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccess:)
                                                 name:DMNotification_LogOut_Success_Key
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDynamicList:)
                                                 name:DMNotification_Follw_Success_Key
                                               object:nil];
}

- (void)logoutSuccess:(NSNotification *)notification {
    [self delayMethodShowPeopleView];
}

- (void)updateUserInfo:(NSNotification *)notification {
    NSString *hasCollection = [AccountInfo getHasFollowStatus];
    self.roleListDatas = [NSMutableArray array];
    self.noFollowIDs = [NSMutableArray array];//不关注的roleID列表
    [self.attentListDatas removeAllObjects];
    self.lastID = @"-1";
    self.firstID = @"";
    self.lastPeopleID = @"-1";
    if (hasCollection.intValue > 0) {
        [self addRefreshLoadMore:self.contentListView.aTableView];
        [self.contentListView.aTableView reloadData];
        [self removePeopleListView];
        [self attentDynamicList];
    } else {
        [self.view addSubview:self.apListView];
        [self addRefreshLoadMore:self.apListView.aTableView];
        [self getRoleListData];
    }
}
- (void)updateDynamicList:(NSNotification *)notification {
    _isNotificationGetDynamicData = YES;
    [self getAttentListData];
}

- (void)getAttentListData {
    if (self.isNotificationGetDynamicData) {
        self.isNotificationGetDynamicData = NO;
        [self removePeopleListView];
        [self addRefreshLoadMore:self.contentListView.aTableView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.roleListDatas = [NSMutableArray array];
    self.noFollowIDs = [NSMutableArray array];//不关注的roleID列表
    self.lastPeopleID = @"-1";
    self.attentListDatas = [NSMutableArray array];
    self.lastID = @"-1";
    self.firstID = @"";
    [self.view addSubview:self.contentListView];
    NSString *hasCollection = [AccountInfo getHasFollowStatus];
    if (STR_IS_NIL([AccountInfo getUserID]) || hasCollection.integerValue <= 0) {
        [self.view addSubview:self.apListView];
        [self addRefreshLoadMore:self.apListView.aTableView];
    } else {
        [self addRefreshLoadMore:self.contentListView.aTableView];
    }
    
    [self notificationAll];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    if (!STR_IS_NIL([AccountInfo getUserID])) {
        NSString *hasCollection = [AccountInfo getHasFollowStatus];
        if (hasCollection.intValue > 0) {
            if ([self.firstID isEqualToString:@""]) {
                self.lastID = @"-1";
                [self attentDynamicList];
            } else {
                [self refreshDynamicData];
            }
            return;
        }
    }
    self.lastPeopleID = @"-1";
    [self getRoleListData];
}

- (void)loadMore {
    if (!STR_IS_NIL([AccountInfo getUserID])) {
        NSString *hasCollection = [AccountInfo getHasFollowStatus];
        if (hasCollection.intValue > 0) {
            [self attentDynamicList];
            return;
        }
    }
    [self getRoleListData];
}

- (void)getRoleListData {
    WS(weakSelf);
    [AApiModel getRoleListForHome:self.lastPeopleID block:^(BOOL result, NSArray *array) {
        if (result) {
            if (array.count > 0) {
                if (weakSelf.lastPeopleID.intValue > -1) {
                    [weakSelf.roleListDatas addObjectsFromArray:array];
                } else {
                    [weakSelf.roleListDatas removeAllObjects];
                    [weakSelf.roleListDatas addObjectsFromArray:array];
                }
                [weakSelf.apListView updateList:weakSelf.roleListDatas];
                
                PeopleDataModel *model = [array lastObject];
                weakSelf.lastPeopleID = model.roleId;
            }
        }
        [weakSelf endRefreshing:weakSelf.apListView.aTableView];
    }];
}

- (void)requestAttentPeoples {
    NSMutableArray *arrayRoleIDs = [NSMutableArray array];
    for (PeopleDataModel *model in self.roleListDatas) {
        if (![self.noFollowIDs containsObject:model.roleId]) {
            [arrayRoleIDs addObject:[NSNumber numberWithInt:model.roleId.intValue]];
        } else {
            [self.noFollowIDs removeObject:model.roleId];
        }
    }
    WS(weakSelf);
    //添加关注请求接口
    [AApiModel addFollowForUser:arrayRoleIDs block:^(BOOL result) {
        if (result) {
            //[weakSelf attentDynamicList];
            [weakSelf getAttentListData];
            
        } else { }
    }];
}

- (void)clickSelectedPeople:(BOOL)follow roleId:(NSString *)roleId {
    if (follow) {
        //添加关注选择
        if ([self.noFollowIDs containsObject:roleId]) {
            [self.noFollowIDs removeObject:roleId];
        }
    } else {
        //取消关注选择
        if (![self.noFollowIDs containsObject:roleId]) {
            [self.noFollowIDs addObject:roleId];
        }
    }
    NSLog(@"不关注的列表 = %@", self.noFollowIDs);
}

- (void)attentDynamicList {
    WS(weakSelf);
    [AApiModel getHomeAttentList:self.lastID block:^(BOOL result, NSArray *array) {
        if (result) {
            if (weakSelf.lastID.intValue == -1) {
                [weakSelf.attentListDatas removeAllObjects];
            }
            if (!OBJ_IS_NIL(array) && array.count > 0) {
                [weakSelf.attentListDatas addObjectsFromArray:array];
                [weakSelf updataAttentList:weakSelf.attentListDatas];
                if (weakSelf.lastID.intValue == -1) {
                    DynamicListData *model = [array firstObject];
                    weakSelf.firstID = model.postId;
                }
                DynamicListData *model = [array lastObject];
                weakSelf.lastID = model.postId;
                [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
            } else {
                [weakSelf.contentListView.aTableView reloadData];
                [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
                //goto 关注人物列表页
                if (weakSelf.lastID.intValue == -1) {
                    [weakSelf performSelector:@selector(delayMethodShowPeopleView) withObject:nil afterDelay:1.0];
                }
            }
            
        } else {
            [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
        }
        
    }];
}

- (void)refreshDynamicData {
    WS(weakSelf);
    [AApiModel getLatestPostContent:@"1" indexId:self.firstID block:^(BOOL result, RefreshDataSubModel *obj) {
        if (result) {
            if (!OBJ_IS_NIL(obj)) {
//                NSRange range = NSMakeRange(0, [array count]);
//                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//                [weakSelf.attentListDatas insertObjects:array atIndexes:indexSet];
                [weakSelf.attentListDatas removeAllObjects];
                if (obj.latestPost.count > 0) {
                    [weakSelf.attentListDatas addObjectsFromArray:obj.latestPost];
                    DynamicListData *model = [obj.latestPost firstObject];
                    weakSelf.firstID = model.postId;
                }
                if (obj.oldPost.count > 0) {
                    [weakSelf.attentListDatas addObjectsFromArray:obj.oldPost];
                    DynamicListData *modelLast = [obj.oldPost lastObject];
                    weakSelf.lastID = modelLast.postId;
                }
                [weakSelf updataAttentList:weakSelf.attentListDatas];
                [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
                
                if (obj.latestPost.count <= 0 && obj.oldPost.count <= 0) {
                    [AccountInfo saveUserHasFollow:@"0"];
                    //goto 关注人物列表页
                    [weakSelf performSelector:@selector(delayMethodShowPeopleView) withObject:nil afterDelay:1.0];
                }
                
            } else {
                [weakSelf.contentListView.aTableView reloadData];
                [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
                //goto 关注人物列表页
                [weakSelf performSelector:@selector(delayMethodShowPeopleView) withObject:nil afterDelay:1.0];
            }
        } else {
            [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
        }
    }];
}

- (void)delayMethodShowPeopleView {
    [self showPeopleListView];
}

- (void)clickAttentButton:(id)sender {

    //判断是否登录，没登录去登录页面，登录的话去首页请求关注
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    } else {
        [self requestAttentPeoples];
    }
}

- (void)clickPraiseUser:(id)sender { //点评论
    WS(weakSelf);
    DynamicCommentListData *data = (DynamicCommentListData *)sender;
    if (data.localPraise) {
        [AApiModel delPraiseForUser:data.postId commentId:data.commentId block:^(BOOL result, NSString *praiseNum) {
            if (result) {
                data.localPraise = NO;
                data.praiseNum = praiseNum;//[NSString stringWithFormat:@"%d", data.praiseNum.intValue-1];
            }
            [weakSelf.contentListView.aTableView reloadData];
        }];
    } else {
        [AApiModel addPraiseForUser:data.postId commentId:data.commentId block:^(BOOL result, NSString *praiseNum) {
            if (result) {
                data.localPraise = YES;
                data.praiseNum = praiseNum;//[NSString stringWithFormat:@"%d", data.praiseNum.intValue+1];
            }
            [weakSelf.contentListView.aTableView reloadData];
        }];
    }
}

- (void)clickPraiseFabulous:(id)sender  view:(id)viewSelf {
    //WS(weakSelf);
    DynamicListData *data = (DynamicListData *)sender;
    ContentCom *cc = (ContentCom *)viewSelf;
    if (data.localPraise) {
        [AApiModel delFabulousForUser:data.postId block:^(BOOL result, NSString *praiseNum) {
            if (result) {
                data.localPraise = NO;
                data.fabulousNum = praiseNum;//[NSString stringWithFormat:@"%d", data.praiseNum.intValue-1];
            }
            [cc updateFabulous];
        }];
       
    } else {
        [AApiModel addFabulousForUser:data.postId block:^(BOOL result, NSString *praiseNum) {
            if (result) {
                data.localPraise = YES;
                data.fabulousNum = praiseNum;//[NSString stringWithFormat:@"%d", data.praiseNum.intValue+1];
            }
            [cc updateFabulous];
        }];
        
    }
}

- (void)clickFavUser:(id)sender view:(id)viewSelf {
    DynamicListData *obj = (DynamicListData *)sender;
    ContentCom *cc = (ContentCom *)viewSelf;
    if (obj.hasCollection.intValue == 0) {
        [AApiModel addCollectionForUser:obj.postId roleId:obj.roleId block:^(BOOL result) {
            if (result) {
                obj.hasCollection = @"1";
                [cc updateCollectionView];
            }
        }];
    } else {
        [AApiModel delCollectionForUser:obj.postId block:^(BOOL result) {
            if (result) {
                obj.hasCollection = @"0";
                [cc updateCollectionView];
            }
        }];
    }
}

- (void)clickSelectRowAtIndexPath:(id)obj {
    DynamicListData *data = (DynamicListData *)obj;
    DynamicDetailsViewController *ddVC = [[DynamicDetailsViewController alloc] init];
    ddVC.postID = data.postId;
    [self.navigationController pushViewController:ddVC animated:YES];
}

- (void)clickPeopleHead:(NSString *)roleID {
    PeopleDetailsViewController *peopleVC = [[PeopleDetailsViewController alloc] init];
    peopleVC.roleID = roleID;
    [self.navigationController pushViewController:peopleVC animated:YES];
}

- (void)clickVideoListPlay:(Info_Type)type videoUrl:(NSString *)videoUrl {
    //videoUrl = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
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

-(void)updataAttentList:(NSMutableArray *)array {
    [self.contentListView updateList:array];
}

- (void)removePeopleListView {
    if (self.apListView != nil) {
        self.apListView.hidden = YES;
        [self.apListView removeFromSuperview];
        self.apListView = nil;
        [self.roleListDatas removeAllObjects];
    }
}

- (void)showPeopleListView {
    [AccountInfo saveUserHasFollow:@"0"];
    [self removePeopleListView];
    [self.view addSubview:self.apListView];
    self.apListView.hidden = NO;
//    self.contentListView.hidden = YES;
    [self addRefreshLoadMore:self.apListView.aTableView];
    
    [self.attentListDatas removeAllObjects];
    self.lastID = @"-1";
    self.firstID = @"";
}

-(AttentionPeopleList *)apListView{
    if (_apListView == nil) {
        _apListView = [[AttentionPeopleList alloc] initWithFrame:
                       CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-DMNavigationBarHeight) delegate:self];
        _apListView.backgroundColor = [UIColor whiteColor];
    }
    return _apListView;
}

- (ContentListView *)contentListView {
    if (_contentListView == nil) {
        _contentListView = [[ContentListView alloc] initWithFrame:
                            CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-DMNavigationBarHeight) delegate:self withType:ContentCom_Type_LineNumber];
        _contentListView.delegate = self;
        _contentListView.backgroundColor = [UIColor whiteColor];
    }
    return _contentListView;
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

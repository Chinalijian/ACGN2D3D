//
//  SquareViewController.m
//  acgn
//
//  Created by lijian on 2018/2/5.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "SquareViewController.h"
#import "ContentListView.h"
@interface SquareViewController () <ContentListDelegate, ContentComDelegate>
@property (nonatomic, strong) ContentListView *contentListView;
@property (nonatomic, strong) NSString *lastID;
@property (nonatomic, strong) NSString *firstID;
@property (nonatomic, strong) NSMutableArray *squareArray;
@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.squareArray = [NSMutableArray array];
    self.lastID = @"-1";
    self.firstID = @"";
    [self.view addSubview:self.contentListView];
    [self addRefreshLoadMore:self.contentListView.aTableView];
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
    
    if ([self.firstID isEqualToString:@""]) {
        self.lastID = @"-1";
        [self getSquareListData];
    } else {
        [self refreshSquareListData];
    }
}

- (void)loadMore {
    [self getSquareListData];
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

- (void)getSquareListData {
    WS(weakSelf);
    [AApiModel getHomePostList:self.lastID block:^(BOOL result, NSArray *array) {
        if (result) {
            if (array.count > 0) {
                if (weakSelf.lastID.intValue > -1) {
                    [weakSelf.squareArray addObjectsFromArray:array];
                } else {
                    [weakSelf.squareArray removeAllObjects];
                    [weakSelf.squareArray addObjectsFromArray:array];
                }
                [weakSelf updataAttentList:weakSelf.squareArray];
                if (weakSelf.lastID.intValue == -1) {
                    DynamicListData *model = [array firstObject];
                    weakSelf.firstID = model.postId;
                }
                DynamicListData *model = [array lastObject];
                weakSelf.lastID = model.postId;

            } else {

            }
        }
        [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
    }];
}

- (void)refreshSquareListData {
    WS(weakSelf);
    [AApiModel getLatestPostContent:@"2" indexId:self.firstID block:^(BOOL result, RefreshDataSubModel *obj) {
        if (result) {
            if (!OBJ_IS_NIL(obj)) {
                [weakSelf.squareArray removeAllObjects];
                if (obj.latestPost.count > 0) {
                    [weakSelf.squareArray addObjectsFromArray:obj.latestPost];
                    DynamicListData *model = [obj.latestPost firstObject];
                    weakSelf.firstID = model.postId;
                }
                if (obj.oldPost.count > 0) {
                    [weakSelf.squareArray addObjectsFromArray:obj.oldPost];
                    DynamicListData *modelLast = [obj.oldPost lastObject];
                    weakSelf.lastID = modelLast.postId;
                }
                [weakSelf updataAttentList:weakSelf.squareArray];
            } else { }
        } else { }
        [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
    }];
}


- (void)clickPraiseUser:(id)sender {
    WS(weakSelf);
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
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
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
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
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
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

- (void)clickAttForUser:(id)sender view:(id)viewSelf {
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    DynamicListData *obj = (DynamicListData *)sender;
    ContentCom *cc = (ContentCom *)viewSelf;
    [AApiModel addFollowForUser:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:obj.roleId.intValue]] block:^(BOOL result) {
        if (result) {
            obj.hasFollow = @"1";
            [cc updateAttentView];
        }
    }];
}

- (ContentListView *)contentListView {
    if (_contentListView == nil) {
        _contentListView = [[ContentListView alloc] initWithFrame:
                            CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-DMNavigationBarHeight) delegate:self withType:ContentCom_Type_LineNumber];
   
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

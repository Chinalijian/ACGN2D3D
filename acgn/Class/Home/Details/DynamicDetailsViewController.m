//
//  DynamicDetailsViewController.m
//  acgn
//
//  Created by lijian on 2018/2/11.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "DynamicDetailsViewController.h"
#import "ContentListView.h"
#import "MsgDetailViewController.h"
@interface DynamicDetailsViewController () <ContentListDelegate, SendMsgDeInputDelegate>
@property (nonatomic, strong) ContentListView *contentListView;
@property (nonatomic, strong) NSMutableArray *commitArray;
@property (nonatomic, strong) NSString *lastID;

@property (nonatomic, strong) NSMutableArray *detailsData;
@property (nonatomic, strong) DynamicListData *obj;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) SendMsgInputTextView *inputView;

@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) UIView *hiddenInputView;
@property (nonatomic, strong) UIView *tempNavBar;
@end

@implementation DynamicDetailsViewController
#define  NAV_H [ATools getNavViewFrameHeightForIPhone]
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.lastID = @"-1";
    self.detailsData = [NSMutableArray array];
    self.commitArray = [NSMutableArray array];
    [self.view addSubview:self.contentListView];
    //[self.view addSubview:self.bottomView];
    [self.view addSubview:self.hiddenInputView];
    [self.view addSubview:self.inputView];
    [self addRefreshLoadMore:self.contentListView.aTableView];
    [self.view addSubview:self.tempNavBar];
    self.tempNavBar.alpha = 0;
    [self refresh];
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (statusBarFrameWillChange:) name : UIApplicationWillChangeStatusBarFrameNotification object : nil ];
    
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (layoutControllerSubViews:) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
    
}
- (void)layoutControllerSubViews:(NSNotification*)notification {
    [self changeInputFrame];
}
- (void)statusBarFrameWillChange:(NSNotification*)notification {
    [self changeInputFrame];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self setNavigationBarTransparence:YES titleColor:[UIColor blackColor]];
    //CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    [self changeInputFrame];
}

- (void)changeInputFrame {
    CGFloat HX = 0;
    CGFloat HI = 0;
    if (IS_IPHONE_X) {
        HX = 35;
        HI = 17;
    }
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    if (statusBarRect.size.height == 40) {
        _inputView.frame = CGRectMake(0, DMScreenHeight-50+HI-HX-20, DMScreenWidth, 50+HI);
    } else {
        _inputView.frame = CGRectMake(0, DMScreenHeight-50+HI-HX, DMScreenWidth, 50+HI);
    }
    
    [_inputView rectFrame:_inputView.frame];
}

- (void)loadData {
    [self getPostDetailsData];
}

- (void)clickPraiseUser:(id)sender {
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
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
    if (STR_IS_NIL([AccountInfo getUserID])) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
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

- (void)getPostDetailsData {
    WS(weakSelf);
    [AApiModel getPostDetilsData:self.postID block:^(BOOL result, DynamicListData *obj) {
        if (result) {
            if (!OBJ_IS_NIL(obj)) {
                if (weakSelf.lastID.intValue == -1) {
                    [weakSelf.detailsData removeAllObjects];
                }
                [weakSelf.detailsData addObject:obj];
                weakSelf.obj = obj;
                [weakSelf getPostCommitData];
                [weakSelf updataAttentList:weakSelf.detailsData];
            } else {
                [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
            }
        } else {
            [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
        }
    }];
}

- (void)getPostCommitData {
    WS(weakSelf);
    [AApiModel getPostCommentListData:self.postID lastId:self.lastID block:^(BOOL result, NSArray *array) {
        if (result) {
            if (array.count > 0) {
                if (weakSelf.lastID.intValue == (-1)) {
                    [weakSelf.commitArray removeAllObjects];
                }
                [weakSelf.commitArray addObjectsFromArray:array];
                weakSelf.obj.commentList = weakSelf.commitArray;
                [weakSelf.contentListView detailsCommit];
                [weakSelf updataAttentList:weakSelf.detailsData];
                DynamicCommentListData *model = [array lastObject];
                weakSelf.lastID = model.commentId;
            }
        }
        [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
    }];
}

- (void)clickSelectRowAtIndexPathForCommit:(id)obj {
    DynamicCommentListData *data = (DynamicCommentListData *)obj;
    MsgDetailViewController *msdDetailVC = [[MsgDetailViewController alloc] init];
    msdDetailVC.obj = data;
    [self.navigationController pushViewController:msdDetailVC animated:YES];
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
    self.lastID = @"-1";
    [self loadData];
}

- (void)loadMore {
    [self getPostCommitData];
}


- (void)inputContent:(NSString *)content {
    DynamicCommentListData *resultData = [[DynamicCommentListData alloc] init];
    resultData.commentContext = content;
    resultData.commentUid = [AccountInfo getUserID];
    resultData.postId = self.postID;
    resultData.isRole = @"";
    resultData.parentCommentId = @"";
    resultData.type = @"1";
    resultData.replyId = @"";
    resultData.replyUid = @"";
    resultData.roleId = @"";
    resultData.replyContext = @"";
    
    WS(weakSelf);
    [AApiModel addCommentForUser:resultData block:^(BOOL result) {
        if (result) {
            [weakSelf.inputView cleanTextInfo];
            [weakSelf refresh];
        }
    }];
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

- (void)clickPeopleHead:(NSString *)roleID {
    PeopleDetailsViewController *peopleVC = [[PeopleDetailsViewController alloc] init];
    peopleVC.roleID = roleID;
    [self.navigationController pushViewController:peopleVC animated:YES];
}

-(void)updataAttentList:(NSMutableArray *)array {
    [self.contentListView updateList:array];
}

- (void)tempNavigationBarShowHidden:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0) {
        CGFloat alpha = MIN(1, 1-(120-offsetY)/(120));//计算透明度
        self.tempNavBar.alpha = alpha;
    } else {
        self.tempNavBar.alpha = 0;
    }
}


- (ContentListView *)contentListView {
    if (_contentListView == nil) {
        _contentListView = [[ContentListView alloc] initWithFrame:
                            CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-DMNavigationBarHeight) delegate:self withType:ContentCom_Type_All];
        _contentListView.backgroundColor = [UIColor whiteColor];
    }
    return _contentListView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat B = 50;
        if (IS_IPHONE_X) {
            B = B + 44;
        }
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DMScreenHeight-150, DMScreenWidth, B)];
        _bottomView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    }
    return _bottomView;
}

- (SendMsgInputTextView *)inputView {
    if (_inputView == nil) {
        CGFloat HX = 0;
        CGFloat HI = 0;
        if (IS_IPHONE_X) {
            HX = 35;
            HI = 17;
        }
        _inputView = [[SendMsgInputTextView alloc] initWithFrame:CGRectMake(0, DMScreenHeight-50+HI-HX, DMScreenWidth, 50+HI)];
        _inputView.bgColor = UIColorFromRGB(0xF2F2F2);
        _inputView.showLimitNum = NO;
        _inputView.font = [UIFont systemFontOfSize:18];
        _inputView.limitNum = 1000;
        _inputView.delegate = self;
    }
    return _inputView;
}

- (UIView *)tempNavBar {
    if (!_tempNavBar) {
        _tempNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, NAV_H)];
        _tempNavBar.backgroundColor = [UIColor whiteColor];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NAV_H-0.5, _tempNavBar.frame.size.width, 0.5)];
        lineLabel.backgroundColor = UIColorFromRGB(0x939393);
        [_tempNavBar addSubview:lineLabel];
    }
    return _tempNavBar;
}

- (UIView *)hiddenInputView {
    if (_hiddenInputView == nil) {
        _hiddenInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, DMScreenHeight)];
        _hiddenInputView.userInteractionEnabled = YES;
        _hiddenInputView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenInputViewTap:)];
        [_hiddenInputView addGestureRecognizer:tap];
    }
    return _hiddenInputView;
}

-(void)hiddenInputViewTap:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)showKeyBoard {
    _hiddenInputView.hidden = NO;
}

- (void)hiddenKeyBoard {
    _hiddenInputView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

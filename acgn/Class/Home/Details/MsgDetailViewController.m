//
//  MsgDetailViewController.m
//  acgn
//
//  Created by lijian on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "ContentListCell.h"
@interface MsgDetailViewController () <UITableViewDelegate, UITableViewDataSource, SendMsgDeInputDelegate>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSString *lastID;
@property (nonatomic, strong) SendMsgInputTextView *inputView;
@property (nonatomic, strong) DynamicCommentListData *firstData;
@property (nonatomic, strong) DynamicCommentListData *resultData;
@property (nonatomic, strong) UIView *hiddenInputView;

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"吐槽详情";
    [self setNavigationBarTransparence:NO
                            titleColor:[UIColor blackColor]];
    self.datas = [NSMutableArray array];
    self.resultData = [[DynamicCommentListData alloc] init];
    [self loadUI];
    [self addRefreshLoadMore:self.mTableView];

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
    [self changeInputFrame];
}

- (void)changeInputFrame {
    CGFloat HX = 0;
    CGFloat HI = 0;
    if (IS_IPHONE_X) {
        HX = 35+25;
        HI = 17;
    }
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    if (statusBarRect.size.height == 40) {
        _inputView.frame = CGRectMake(0, DMScreenHeight-DMNavigationBarHeight-50+HI-HX-20, DMScreenWidth, 50+HI);
    } else {
        _inputView.frame = CGRectMake(0, DMScreenHeight-DMNavigationBarHeight-50+HI-HX, DMScreenWidth, 50+HI);
    }
    
    [_inputView rectFrame:_inputView.frame];
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
    [self loadData];
}

- (void)loadMore {
    [self loadData];
}

- (void)loadData {
    WS(weakSelf);
    [AApiModel getGetCommentDetailsData:self.obj.commentId lastId:self.lastID block:^(BOOL result, MsgCommitData *obj) {
        if (result) {
            if (!OBJ_IS_NIL(obj)) {
                if (weakSelf.lastID.integerValue == -1) {
                    [weakSelf.datas removeAllObjects];
                    if (!OBJ_IS_NIL(obj.firstComment)) {
                        weakSelf.firstData = obj.firstComment;
                        [weakSelf.datas addObject:obj.firstComment];
                        [weakSelf.inputView setAlpLabel:obj.firstComment.userName];
                        [weakSelf sendMsgObj:weakSelf.firstData index:0];
                    }
                }
                if (obj.secondComment.count > 0) {
                    [weakSelf.datas addObjectsFromArray:obj.secondComment];
                    DynamicCommentListData *data = [weakSelf.datas lastObject];
                    weakSelf.lastID = data.commentId;
                }
            }
            [weakSelf.mTableView reloadData];
        }
        [weakSelf endRefreshing:weakSelf.mTableView];
    }];
    
}
- (void)sendMsgObj:(DynamicCommentListData *)obj index:(NSInteger)index {
    if (OBJ_IS_NIL(self.resultData)) {
        self.resultData = [[DynamicCommentListData alloc] init];
    }
    self.resultData.type = @"2";
    self.resultData.parentCommentId = obj.commentId;
    self.resultData.postId = obj.postId;
    self.resultData.replyId = obj.commentId;
    self.resultData.isRole = obj.isRole;
    self.resultData.replyContext = obj.commentContext;
    self.resultData.replyUid = [AccountInfo getUserID];
    if (obj.isRole.integerValue == 1) {//角色
        self.resultData.roleId = obj.roleId;
        if (index == 0) {
            self.resultData.commentUid = @"0";
        } else {
            self.resultData.commentUid = self.firstData.commentUid;
        }
    } else {
        self.resultData.roleId = @"0";
        if (index == 0) {
            self.resultData.commentUid = obj.commentUid;
        } else {
            self.resultData.commentUid = obj.replyUid;
        }
    }
}

- (void)inputContent:(NSString *)content {
    if (OBJ_IS_NIL(self.resultData)) {
        [ATools showSVProgressHudCustom:@"" title:@"请编辑内容进行吐槽"];
        return;
    }
    self.resultData.commentContext = content;
    WS(weakSelf);
    [AApiModel addCommentForUser:self.resultData block:^(BOOL result) {
        if (result) {
            [weakSelf.inputView cleanTextInfo];
            weakSelf.resultData = nil;
            [weakSelf refresh];
        }
    }];
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.datas.count) {
        DynamicCommentListData *obj = [self.datas objectAtIndex:indexPath.row];
        [self.inputView setAlpLabel:obj.userName];
        [self sendMsgObj:obj index:indexPath.row];
    }
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.datas.count) {
        DynamicCommentListData *data = [self.datas objectAtIndex:indexPath.row];
        CGFloat h = [ContentListCell getCellMaxHeightAndUpdate:data];
        return h;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cListCell = @"ContentListCellD";
    ContentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cListCell];
    if (!cell) {
        cell = [[ContentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cListCell];
        [self showLineForTableView:cell];
    }
    if (indexPath.row < self.datas.count) {
        DynamicCommentListData *data = [self.datas objectAtIndex:indexPath.row];
        [cell configDynamicObj:data];
    }
    if (indexPath.row == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF5FAFD);
    } else {
        cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
    
    
    return cell;
}

- (void)showLineForTableView:(ContentListCell *)cell {
    UILabel *lineLable = [[UILabel alloc] init];
    lineLable.backgroundColor = UIColorFromRGB(0xC3C3C3);
    [cell addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(cell.mas_bottom).offset(0);
        make.height.mas_offset(1);
        make.left.right.mas_equalTo(cell).offset(0);
    }];
}

- (void)loadUI {
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.hiddenInputView];
    [self.view addSubview:self.inputView];
}

#pragma mark - 初始化UIKIT
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-DMNavigationBarHeight) style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = [UIColor whiteColor];

    }
    return _mTableView;
}
- (SendMsgInputTextView *)inputView {
    if (_inputView == nil) {
        CGFloat HX = 0;
        CGFloat HI = 0;
        if (IS_IPHONE_X) {
            HX = 35;
            HI = 17;
        }
        _inputView = [[SendMsgInputTextView alloc] initWithFrame:CGRectMake(0, DMScreenHeight-DMNavigationBarHeight-50+HI-HX, DMScreenWidth, 50+HI)];
        _inputView.bgColor = UIColorFromRGB(0xF2F2F2);
        _inputView.showLimitNum = NO;
        _inputView.font = [UIFont systemFontOfSize:18];
        _inputView.limitNum = 1000;
        _inputView.delegate = self;
    }
    return _inputView;
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

@end

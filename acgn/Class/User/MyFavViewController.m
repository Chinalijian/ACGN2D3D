//
//  MyFavViewController.m
//  acgn
//
//  Created by lijian on 2018/2/5.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "MyFavViewController.h"
#import "ContentListView.h"
@interface MyFavViewController () <ContentListDelegate, EmptyViewDelegate>
@property (nonatomic, strong) ContentListView *contentListView;
@property (nonatomic, strong) NSString *lastID;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation MyFavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTransparence:NO
                            titleColor:[UIColor blackColor]];
    self.lastID = @"-1";
    self.datas = [NSMutableArray array];
    [self.view addSubview:self.emptyView];
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
    self.lastID = @"-1";
    [self loadData];
    
}

- (void)loadMore {
    [self loadData];
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


- (void)clickFavUser:(id)sender view:(id)viewSelf {
    WS(weakSelf);
    DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"是否确定删除？" message:@"" preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" otherTitle:@"确定", nil];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index == 1) { // 右侧
            DynamicListData *obj = (DynamicListData *)sender;
            [AApiModel delCollectionForUser:obj.postId block:^(BOOL result) {
                if (result) {
                    [weakSelf.datas removeObject:obj];
                    [weakSelf updataAttentList:weakSelf.datas];
                    [weakSelf refresh];
                }
            }];
        }
    }];
    
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

-(void)updataAttentList:(NSMutableArray *)array {
    [self.contentListView updateList:array];
}

- (ContentListView *)contentListView {
    if (_contentListView == nil) {
        _contentListView = [[ContentListView alloc] initWithFrame:
                            CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-DMNavigationBarHeight) delegate:self withType:ContentCom_Type_LineNumber];
        _contentListView.backgroundColor = [UIColor whiteColor];
      
        _contentListView.isFavPage = YES;
    }
    return _contentListView;
}

- (void)loadData {
    WS(weakSelf);
    [AApiModel getCollectionListForUser:self.lastID block:^(BOOL result, NSArray *array) {
        if (result) {
            if (weakSelf.lastID.intValue == -1) {
                [weakSelf.datas removeAllObjects];
            }
            if (!OBJ_IS_NIL(array) && array.count > 0) {
                weakSelf.contentListView.hidden = NO;
                weakSelf.emptyView.hidden = YES;
                
                [weakSelf.datas addObjectsFromArray:array];
                [weakSelf updataAttentList:weakSelf.datas];
                DynamicListData *model = [array lastObject];
                weakSelf.lastID = model.collectionId;
            } else {
                if (self.lastID.intValue == -1 && weakSelf.datas.count == 0) {
                    weakSelf.emptyView.hidden = NO;
                    weakSelf.contentListView.hidden = YES;
                }
            }
        }
        [weakSelf endRefreshing:weakSelf.contentListView.aTableView];
    }];
}
- (EmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, DMScreenHeight-DMNavigationBarHeight) delegate:self];
        _emptyView.backgroundColor = [UIColor whiteColor];
        [_emptyView updateInfo:@"collection_null" title:@"空空如也，什么也没有" btnTitle:@""];
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

//
//  ContentListView.m
//  acgn
//
//  Created by Ares on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ContentListView.h"
#import "ContentListCell.h"
#import "ContentCom.h"
#import "DynamicEmptyCell.h"
@interface ContentListView() <UITableViewDelegate,
UITableViewDataSource, ContentComDelegate, ContentListCellDelegate>
@property (nonatomic, strong) DynamicEmptyCell *emptyCell;
@property (nonatomic, assign) BOOL commitDataStatus;//是否是动态详情页面的评论数据
@end

@implementation ContentListView

- (void)testData {
    NSArray *array = [NSArray arrayWithObjects:
                      @"http://img.ui.cn/data/file/5/0/0/1574005.png",
                      @"http://img.ui.cn/data/file/8/0/0/1574008.png",
                      @"http://img.ui.cn/data/file/7/0/0/1574007.png",
                      @"http://img.ui.cn/data/file/1/8/9/1573981.png",
                      @"http://img.ui.cn/data/file/1/7/9/1573971.png", nil];
    for (int i = 0; i < array.count; i ++) {
        PeopleDataModel *obj = [[PeopleDataModel alloc] init];
        obj.imageUrl = [array objectAtIndex:i];
        obj.userName = [NSString stringWithFormat:@"东方红叶%d", i];
        obj.fansNum = [NSString stringWithFormat:@"%d", i+100];
        obj.source = [NSString stringWithFormat:@"中国%d", i];
        [self.datas addObject:obj];
    }
    
}

- (id)initWithFrame:(CGRect)frame delegate:(id<ContentListDelegate>) delegate withType:(ContentCom_Type)ccType {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.ccType = ccType;
        self.datas = [NSMutableArray array];
        //[self testData];
        [self loadUI];
    }
    return self;
}
- (void)updateFabulous {
    
}

- (void)detailsCommit {
    self.commitDataStatus = YES;
}

- (void)updateList:(NSMutableArray *)array {
    self.datas = array;
    [self.aTableView reloadData];
    if (self.emptyCell) {
        if (self.ccType == ContentCom_Type_All) {
            if (array.count > 0 && self.commitDataStatus) {
                self.emptyCell.hidden = NO;
                return;
            }
        }
        self.emptyCell.hidden = YES;
    }
}

- (void)clickSelectedPeople:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag < self.datas.count) {
        PeopleDataModel *obj = [self.datas objectAtIndex:btn.tag];
        obj.isSelected = !obj.isSelected;
    }
    [self.aTableView reloadData];
}

- (CGFloat)getCellMaxHeight:(NSIndexPath *)indexPath {
    DynamicListData *data = [self.datas objectAtIndex:indexPath.section];
    if (!OBJ_IS_NIL(data)) {
        if (data.commentList.count > 0) {
            DynamicCommentListData *dynamicObj = [data.commentList objectAtIndex:indexPath.row];
            CGFloat H = [ContentListCell getCellMaxHeightAndUpdate:dynamicObj];
            return H;
        }
    }
    return 0;
}

- (void)clickSelectPeopleImage:(NSString *)roleId {
    if (!STR_IS_NIL(roleId)) {
        if ([self.delegate respondsToSelector:@selector(clickPeopleHead:)]) {
            [self.delegate clickPeopleHead:roleId];
        }
    }
}

- (void)clickSelectSectionViewForGoToDetail:(id)obj {
    if ([self.delegate respondsToSelector:@selector(clickSelectRowAtIndexPath:)]) {
        [self.delegate clickSelectRowAtIndexPath:obj];
    }
}

- (void)userClickPraise:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickPraiseUser:)]) {
        [self.delegate clickPraiseUser:sender];
    }
}

- (void)clickFavForUser:(id)sender view:(id)viewSelf {
    if ([self.delegate respondsToSelector:@selector(clickFavUser:view:)]) {
        [self.delegate clickFavUser:sender view:viewSelf];
    }
}

- (void)clickPraiseFabulous:(id)sender view:(id)viewSelf {
    if ([self.delegate respondsToSelector:@selector(clickPraiseFabulous:view:)]) {
        [self.delegate clickPraiseFabulous:sender view:viewSelf];
    }
}
- (void)clickAttForUser:(id)sender view:(id)viewSelf {
    if ([self.delegate respondsToSelector:@selector(clickAttForUser:view:)]) {
        [self.delegate clickAttForUser:sender view:viewSelf];
    }
}

- (void)clickVideoPlay:(Info_Type)type videoUrl:(NSString *)videoUrl {
    if ([self.delegate respondsToSelector:@selector(clickVideoListPlay:videoUrl:)]) {
        [self.delegate clickVideoListPlay:type videoUrl:videoUrl];
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(clickSelectRowAtIndexPath:)]) {
        if (indexPath.section < self.datas.count) {
            DynamicListData *data = [self.datas objectAtIndex:indexPath.section];
            [self.delegate clickSelectRowAtIndexPath:data];
        }
    }
    if ([self.delegate respondsToSelector:@selector(clickSelectRowAtIndexPathForCommit:)]) {
        if (indexPath.section < self.datas.count) {
            DynamicListData *data = [self.datas objectAtIndex:indexPath.section];
            if (data.commentList.count > 0) {
                DynamicCommentListData *lData = [data.commentList objectAtIndex:indexPath.row];
                [self.delegate clickSelectRowAtIndexPathForCommit:lData];
            }
        }
    }
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.datas.count) {
        CGFloat H = [self getCellMaxHeight:indexPath];
        return H;
    }
    if (self.ccType == ContentCom_Type_All) {
        return 250;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.datas.count) {
        DynamicListData *data = [self.datas objectAtIndex:section];
        if (!OBJ_IS_NIL(data)) {
            if (data.commentList.count > 0) {
                return data.commentList.count;
            } else {
                if (self.ccType == ContentCom_Type_All) {
                    return 1;//为了显示空白提示页
                }
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cListCell = @"ContentListCell";
    ContentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cListCell];
    if (!cell) {
        cell = [[ContentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cListCell];
        cell.delegate = self;
    }
    
    if (self.datas.count > 0) {
        DynamicListData *data = [self.datas objectAtIndex:indexPath.section];
        if (!OBJ_IS_NIL(data)) {
            if (data.commentList.count > 0) {
                DynamicCommentListData *dynamicObj = [data.commentList objectAtIndex:indexPath.row];
                [cell configDynamicObj:dynamicObj];
            } else {
                if (self.ccType == ContentCom_Type_All) {
                    static NSString *emptyListCell = @"DynamicEmptyCell";
                    DynamicEmptyCell *cellempty = [tableView dequeueReusableCellWithIdentifier:emptyListCell];
                    if (!cellempty) {
                        cellempty = [[DynamicEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyListCell];
                        cellempty.hidden = YES;
                        self.emptyCell = cellempty;
                    }
                    return cellempty;
                }
            }
        }
    }
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    static NSString *cc = @"ContentCom";
    ContentCom *infoV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cc];
    if(infoV==nil) {
        infoV = [[ContentCom alloc]
                 initWithReuseIdentifier:cc
                 frame:CGRectMake(0, 0, self.aTableView.frame.size.width, 0) contentComType:self.ccType];
    }
    infoV.delegate = self;
    [self modfiyBackgroudColor:infoV index:section];
    if (section < self.datas.count) {
        DynamicListData *data = [self.datas objectAtIndex:section];
        data.favPage = self.isFavPage;
        if (self.isFavPage) {
            data.hasCollection = @"1";
        }
        [infoV configInfo:data];
    }
    return infoV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < self.datas.count) {
        DynamicListData *data = [self.datas objectAtIndex:section];
        if(!OBJ_IS_NIL(data)) {
            return [ContentCom getContentCommonCellHeight:data contentType:self.ccType];
        }
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, 0.000001)];
    infoV.backgroundColor = [UIColor whiteColor];
    return infoV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (void)modfiyBackgroudColor:(ContentCom *)view index:(NSInteger)index {
    switch (index%3) {
        case 0:
            view.contentView.backgroundColor = Head_Blue_Color;
            break;
        case 1:
            view.contentView.backgroundColor = Head_Yellow_Color;
            break;
        case 2:
            view.contentView.backgroundColor = Head_Red_Color;
            break;
        default:
            break;
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.ccType == ContentCom_Type_All) {
        if ([self.delegate respondsToSelector:@selector(tempNavigationBarShowHidden:)]) {
            [self.delegate tempNavigationBarShowHidden:scrollView];
        }
    }
}

#pragma mark - 初始化UIKIT
- (void)loadUI {
    [self addSubview:self.aTableView];
}

- (UITableView *)aTableView {
    if (!_aTableView) {
        _aTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _aTableView.delegate = self;
        _aTableView.dataSource = self;
        //_aTableView.scrollEnabled = NO;
        _aTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _aTableView.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
        self.aTableView.estimatedRowHeight = 0;
        self.aTableView.estimatedSectionHeaderHeight = 0;
        self.aTableView.estimatedSectionFooterHeight = 0;
        UIView *fV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _aTableView.frame.size.width, 35)];
        fV.backgroundColor = [UIColor whiteColor];
        _aTableView.tableFooterView = fV;
        if (@available(iOS 11.0, *)) {
            _aTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _aTableView;
}

@end

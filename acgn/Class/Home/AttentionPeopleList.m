//
//  AttentionPeopleList.m
//  acgn
//
//  Created by Ares on 2018/2/1.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "AttentionPeopleList.h"
#import "PeopleListCell.h"
#import "PeopleListDataModel.h"
@interface AttentionPeopleList ()

@property (nonatomic, strong) UIButton *attBtn;

@property (nonatomic, strong) UIView *topHeadView;
@property (nonatomic, strong) UILabel *bigTitleLabel;
@property (nonatomic, strong) UILabel *smallTitleLabel;

@end

@implementation AttentionPeopleList

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

- (id)initWithFrame:(CGRect)frame delegate:(id<AttentionPeopleListDelegate>) delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.datas = [NSMutableArray array];
        //[self testData];
        [self loadUI];
    }
    return self;
}

- (void)updateList:(NSMutableArray *)array {
    self.datas = array;
    [self.aTableView reloadData];
}

- (void)clickAttentButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickAttentButton:)]) {
        [self.delegate clickAttentButton:sender];
    }
}

- (void)clickSelectedPeople:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag < self.datas.count) {
        PeopleDataModel *obj = [self.datas objectAtIndex:btn.tag];
        obj.isSelected = !obj.isSelected;
        if ([self.delegate respondsToSelector:@selector(clickSelectedPeople:roleId:)]) {
            [self.delegate clickSelectedPeople:obj.isSelected roleId:obj.roleId];
        }
    }
    [self.aTableView reloadData];
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return People_List_Cell_H;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.datas.count/2+self.datas.count%2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *peopleCell = @"peopleCell";
    PeopleListCell *cell = [tableView dequeueReusableCellWithIdentifier:peopleCell];
    if (!cell) {
        cell = [[PeopleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:peopleCell];
        [cell.leftView.selectedBtn addTarget:self action:@selector(clickSelectedPeople:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightView.selectedBtn addTarget:self action:@selector(clickSelectedPeople:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    if (self.datas.count > 0) {
        cell.leftView.selectedBtn.tag = indexPath.row*2;
        cell.rightView.selectedBtn.tag = indexPath.row*2+1;
        if (indexPath.row < self.datas.count/2+self.datas.count%2) {
            if (self.datas.count%2 != 0 && indexPath.row == self.datas.count/2) {
                //奇数
                [cell configPeopleInfo:[self.datas objectAtIndex:indexPath.row*2]
                              objRight:nil];
            } else {
                //偶数
                [cell configPeopleInfo:[self.datas objectAtIndex:indexPath.row*2]
                              objRight:[self.datas objectAtIndex:indexPath.row*2+1]];
            }
        }
    }
    
    return cell;
}

- (void)loadUI {
    [self addSubview:self.aTableView];
    [self addSubview:self.attBtn];
    [self setupMakeLayoutSubviews];
}

- (void)setupMakeLayoutSubviews {
    
    [_bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topHeadView).mas_offset(25);
        make.height.mas_offset(18);
        make.left.mas_equalTo(_topHeadView).mas_offset(0);
        make.right.mas_equalTo(_topHeadView).mas_offset(0);
        make.centerX.mas_equalTo(_topHeadView);
    }];
    [_smallTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15);
        make.left.mas_equalTo(_topHeadView).mas_offset(0);
        make.right.mas_equalTo(_topHeadView).mas_offset(0);
        make.bottom.mas_equalTo(_topHeadView).mas_offset(-4);
    }];
    
    [_attBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(94/2);
        make.right.mas_equalTo(self).mas_offset(-94/2);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(-([ATools setViewFrameBottomForIPhoneX:15]));
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - 初始化UIKIT
- (UITableView *)aTableView {
    if (!_aTableView) {
        _aTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _aTableView.delegate = self;
        _aTableView.dataSource = self;
        //_aTableView.scrollEnabled = NO;
        _aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _aTableView.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
        _aTableView.tableHeaderView = self.topHeadView;
        self.aTableView.estimatedRowHeight = 0;
        self.aTableView.estimatedSectionHeaderHeight = 0;
        self.aTableView.estimatedSectionFooterHeight = 0;
        UIView *fV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _aTableView.frame.size.width, 70)];
        fV.backgroundColor = [UIColor whiteColor];
        _aTableView.tableFooterView = fV;
    }
    return _aTableView;
}

- (UIView *)topHeadView {
    if (_topHeadView == nil) {
        _topHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, 70)];
        _topHeadView.backgroundColor = [UIColor whiteColor];
        [_topHeadView addSubview:self.bigTitleLabel];
        [_topHeadView addSubview:self.smallTitleLabel];
    }
    return _topHeadView;
}

- (UILabel *)bigTitleLabel {
    if (_bigTitleLabel == nil) {
        _bigTitleLabel = [[UILabel alloc] init];
        _bigTitleLabel.text = @"你还没有关注的人";
        _bigTitleLabel.textAlignment = NSTextAlignmentCenter;
        _bigTitleLabel.textColor = UIColorFromRGB(0xEB6977);
        _bigTitleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _bigTitleLabel;
}

- (UILabel *)smallTitleLabel {
    if (_smallTitleLabel == nil) {
        _smallTitleLabel = [[UILabel alloc] init];
        _smallTitleLabel.text = @"勾选关注，可以看到他们发布有趣的事";
        _smallTitleLabel.textAlignment = NSTextAlignmentCenter;
        _smallTitleLabel.textColor = UIColorFromRGB(0x8B8B8B);
        _smallTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _smallTitleLabel;
}

- (UIButton *)attBtn {
    if (_attBtn == nil) {
        _attBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attBtn setTitle:@"关注他们" forState:UIControlStateNormal];
        [_attBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _attBtn.backgroundColor = UIColorFromRGB(0xE96A79);
        _attBtn.layer.cornerRadius = 15;
        [_attBtn addTarget:self action:@selector(clickAttentButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attBtn;
}


@end

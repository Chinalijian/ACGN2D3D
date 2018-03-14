//
//  UserView.m
//  acgn
//
//  Created by lijian on 2018/2/3.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "UserView.h"
#import "UserCell.h"
#import "LoginViewController.h"
#import "UMLoginPublicClass.h"
@interface UserView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) ComonTop *topView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation UserView
#define X_SPACE 20
#define User_TableViewCell_H 65
#define TopView_H 198
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatas];
        [self loadUI];
        [self updateUserInfo];
        [self tapGestureRecognizer];
    }
    return self;
}

- (void)updateUserInfo {
    [self upDateTopInfo];
}

- (void)upDateTopInfo {
    if (STR_IS_NIL([AccountInfo getUserID])) {
        self.topView.logoNameLabel.text = @"登录";
        self.topView.logoImageView.image = [UIImage imageNamed:@"public_logo"];
        self.logoutButton.hidden = YES;
    } else {
        [self.topView.logoImageView sd_setImageWithURL:[NSURL URLWithString:[AccountInfo getUserHeadUrl]] placeholderImage:[UIImage imageNamed:@"public_logo"]];
        self.topView.logoNameLabel.text = [AccountInfo getUserName];
        self.logoutButton.hidden = NO;
    }
}

- (void)initDatas {
    self.datas = [NSMutableArray arrayWithObjects:@"我的消息",@"我的收藏",@"密码设置",@"关于我们",@"版本信息", nil];
    self.images = [NSMutableArray arrayWithObjects:@"msg_icon",@"fav_icon",@"psd_icon",@"abo_icon",@"ver_icon", nil];
}

- (void)clickLogoutSure:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickLogoutSystem)]) {
        [self.delegate clickLogoutSystem];
    }
}

//创建轻拍手势
-(void)tapGestureRecognizer {
    //创建手势对象
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //轻拍次数
    tap.numberOfTapsRequired = 1;
    //轻拍手指个数
    tap.numberOfTouchesRequired = 1;
    //讲手势添加到指定的视图上
    [_topView.logoImageView addGestureRecognizer:tap];
}

//轻拍事件

-(void)tapAction:(UITapGestureRecognizer *)tap {
    if (STR_IS_NIL([AccountInfo getUserID])) {
        if ([self.delegate respondsToSelector:@selector(clickTopGotoLogin)]) {
            [self.delegate clickTopGotoLogin];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(clickTopGotoNikeNamePage)]) {
            [self.delegate clickTopGotoNikeNamePage];
        }
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(goToPage:)]) {
        switch (indexPath.row) {
            case 0:
                [self.delegate goToPage:AAccountType_Msg];
                break;
            case 1:
                [self.delegate goToPage:AAccountType_Fav];
                break;
            case 2:
                [self.delegate goToPage:AAccountType_ChangePsd];
                break;
            case 3:
                [self.delegate goToPage:AAccountType_About];
                break;
            default:
                break;
        }
    }

}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return User_TableViewCell_H;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userCell = @"userCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
    if (!cell) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCell];
    }
    [cell configInfo:[self.images objectAtIndex:indexPath.row] title:[self.datas objectAtIndex:indexPath.row]];
    if (indexPath.row == self.datas.count-1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = [@"V" stringByAppendingString:App_Version];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.rightLabel.hidden = YES;
        cell.rightLabel.text = @"";
    }
    if (indexPath.row == 0) {
        if (self.hasNoMsg) {
            cell.redPointLabel.hidden = NO;
        } else {
            cell.redPointLabel.hidden = YES;
        }
        
    } else {
        cell.redPointLabel.hidden = YES;
    }
    return cell;
}

#pragma make - UI init
- (void)loadUI {
    
    [self addSubview:self.uTableView];
    // 新API：`@available(iOS 11.0, *)` 可用来判断系统版本
    if ( @available(iOS 11.0, *) ) {
        self.uTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
   
    [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bottomView.mas_bottom).mas_offset(-10);
        make.left.mas_equalTo(_bottomView).mas_offset(X_SPACE);
        make.right.mas_equalTo(_bottomView).mas_offset(-X_SPACE);
        make.height.mas_equalTo(44);
    }];
    
}

#pragma mark - 初始化UIKIT
- (UITableView *)uTableView {
    if (!_uTableView) {
        _uTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _uTableView.delegate = self;
        _uTableView.dataSource = self;
        //_uTableView.scrollEnabled = NO;
        _uTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _uTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _uTableView.tableHeaderView = self.topView;
        _uTableView.tableFooterView = self.bottomView;
    }
    return _uTableView;
}

- (ComonTop *)topView {
    if (_topView == nil) {
        _topView = [[ComonTop alloc] initWithFrame:CGRectMake(0, 0, self.uTableView.frame.size.width, [ATools setViewFrameYForIPhoneX:TopView_H])];
        _topView.logoImageView.clipsToBounds = YES;
        _topView.logoImageView.layer.cornerRadius = (70.5)/2;
    }
    return _topView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat bSpace = [ATools setViewFrameBottomForIPhoneX:TopView_H];
        CGFloat bottomH = self.uTableView.frame.size.height-User_TableViewCell_H*self.datas.count-bSpace;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.uTableView.frame.size.width, bottomH)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.bottomView addSubview:self.logoutButton];
        
    }
    return _bottomView;
}

- (UIButton *)logoutButton {
    if (_logoutButton == nil) {
        _logoutButton = [[UIButton alloc] init];
        _logoutButton.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _logoutButton.layer.cornerRadius = 15;
        //        _loginButton.layer.borderColor = UIColorFromRGB(0xBAB8B9).CGColor;
        //        _loginButton.layer.borderWidth = .5;
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_logoutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [_logoutButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _logoutButton.alpha = 0.6;
        [_logoutButton addTarget:self action:@selector(clickLogoutSure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}


@end

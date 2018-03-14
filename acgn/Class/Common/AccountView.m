//
//  AccountView.m
//  acgn
//
//  Created by Ares on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "AccountView.h"
#import "AccountCell.h"

@interface AccountView()
@property (nonatomic, assign) AAccountType aType;
@property (nonatomic, copy) NSString *buttonTitle;

@property (nonatomic, strong) NSArray *titleImages;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *logoNameLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIView *otherView;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *resetPsdButton;
@property (nonatomic, strong) UIView *thirdPartyView;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *wecatButton;
@property (nonatomic, strong) UIButton *weiboButton;

@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger tCount;

@end

@implementation AccountView
#define X_SPACE 47
#define TableViewCell_H 60
#define TopView_H 198
#define Time_Count 60
- (id)initWithFrame:(CGRect)frame type:(AAccountType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.aType = type;
        [self initDatas];
        [self loadUI];
    }
    return self;
}

- (void)initDatas {
    self.datas = [NSMutableArray array];
    self.buttonTitle = @"确定";
    NSString *content = @"";
    switch (self.aType) {
        case AAccountType_Login:
            self.titleImages = [NSArray arrayWithObjects:@"phone_icon", @"psd_icon", nil];
            self.placeholders = [NSArray arrayWithObjects:@"请输入你的手机号码", @"请输入你的登录密码", nil];
            break;
        case AAccountType_Register:
            self.titleImages = [NSArray arrayWithObjects:@"phone_icon", @"yzm_icon", @"psd_icon", nil];
            self.placeholders = [NSArray arrayWithObjects:@"请输入你的手机号码", @"请输入收到的验证码", @"请设置6-16位新密码", nil];
            //self.buttonTitle = @"下一步";
            break;
        case AAccountType_ResetPsd:
            self.titleImages = [NSArray arrayWithObjects:@"phone_icon", @"yzm_icon", nil];
            self.placeholders = [NSArray arrayWithObjects:@"请输入你的手机号码", @"请输入收到的验证码", nil];
            self.buttonTitle = @"下一步";
            break;
        case AAccountType_SetPsd:
            self.titleImages = [NSArray arrayWithObjects:@"psd_icon", @"psd_icon", nil];
            self.placeholders = [NSArray arrayWithObjects:@"请设置6-16位新密码", @"请再次输入新密码", nil];
            break;
        case AAccountType_NickName:
            self.titleImages = [NSArray arrayWithObjects:@"name_icon", nil];
            self.placeholders = [NSArray arrayWithObjects:@"我的昵称", nil];
            content = [AccountInfo getUserName];
            break;
        case AAccountType_ChangePsd:
            self.titleImages = [NSArray arrayWithObjects:@"psd_icon", @"psd_icon", @"psd_icon", nil];
            self.placeholders = [NSArray arrayWithObjects:@"请输入当前密码", @"请设置6-16位新密码", @"请再次输入新密码", nil];
            break;
        case AAccountType_BindPhone:
            self.titleImages = [NSArray arrayWithObjects:@"phone_icon", @"yzm_icon", @"psd_icon", nil];
            self.placeholders = [NSArray arrayWithObjects:@"请输入你的手机号码", @"请输入收到的验证码", @"请设置6-16位新密码", nil];
            break;
        default:
            break;
    }
    for (int i = 0; i < self.titleImages.count; i++) {
        AccountLocalDataModel *model = [[AccountLocalDataModel alloc] init];
        model.placeholder = [self.placeholders objectAtIndex:i];
        model.titleImage = [self.titleImages objectAtIndex:i];
        model.content = content;
        [self.datas addObject:model];
    }
}

- (void)updateHeadUrlAndNickName {
    if (self.aType == AAccountType_NickName) {
        NSString * imageUrls = [[AccountInfo getUserHeadUrl] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrls]
                              placeholderImage:[UIImage imageNamed:@"public_logo"]];
        self.logoNameLabel.text = [AccountInfo getUserName];
    }
}

- (void)addTimerForCode {
    // 加1个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
    if (self.tCount != 1) {
        self.tCount -= 1;
        self.codeButton.enabled = NO;
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒", self.tCount] forState:UIControlStateNormal];
    } else {
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"获取" forState:UIControlStateNormal];
        [self.timer invalidate];
    }
}

- (void)timeFailBeginFrom:(NSInteger)timeCount {
    self.tCount = timeCount;
    self.codeButton.enabled = NO;
    [self addTimerForCode];
}

- (void)clickSure:(id)sender {

    if ([self.delegate respondsToSelector:@selector(clickAccountSure:datas:)]) {
        [self.delegate clickAccountSure:sender datas:self.datas];
    }
}

- (void)clickRegister:(id)sender {
    //快速注册
    if ([self.delegate respondsToSelector:@selector(clickAccountRegister:)]) {
        [self.delegate clickAccountRegister:sender];
    }
}

- (void)clickResetPsd:(id)sender {
    //忘记密码
    if ([self.delegate respondsToSelector:@selector(clickAccountResetPsd:)]) {
        [self.delegate clickAccountResetPsd:sender];
    }
}

- (void)clickQQ:(id)sender {
    //qq登录
    if ([self.delegate respondsToSelector:@selector(clickThirdPartyQQ:)]) {
        [self.delegate clickThirdPartyQQ:sender];
    }
}

- (void)clickWecat:(id)sender {
    //微信登录
    if ([self.delegate respondsToSelector:@selector(clickThirdPartyWecat:)]) {
        [self.delegate clickThirdPartyWecat:sender];
    }
}

- (void)clickWeibo:(id)sender {
    //微博登录
    if ([self.delegate respondsToSelector:@selector(clickThirdPartyWeibo:)]) {
        [self.delegate clickThirdPartyWeibo:sender];
    }
}

- (void)clickGetCode:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickGetCode:obj:)]) {
        [self.delegate clickGetCode:sender obj:[self.datas firstObject]];
    }
    [self timeFailBeginFrom:Time_Count];
}

- (void)clickCamera:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickCameraForUser:)]) {
        [self.delegate clickCameraForUser:sender];
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TableViewCell_H;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *accCell = @"accccell";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:accCell];
    if (!cell) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accCell];
    }
    
    [cell configInfo:[self.datas objectAtIndex:indexPath.row]];
    
    if (self.aType == AAccountType_Login) {
        if (indexPath.row == 1) {
            [cell textSwitchSecure:YES];
        } else {
            [cell textSwitchSecure:NO];
        }
    } else if (self.aType == AAccountType_SetPsd || self.aType == AAccountType_ChangePsd) {
        [cell textSwitchSecure:YES];
    } else {
        [cell textSwitchSecure:NO];
    }
    
    if (self.aType == AAccountType_Register || self.aType == AAccountType_ResetPsd || self.aType == AAccountType_BindPhone) {
        if (indexPath.row == 1) {
            [cell.bgView layoutIfNeeded];
            [self initGetCodeButton:cell.bgView];
        }
    }
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.aType == AAccountType_NickName) {
        UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, 30)];
        oneView.backgroundColor = [UIColor whiteColor];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:oneView.bounds];
        [oneView addSubview:tipLabel];
        tipLabel.text = @"系统随机分配了一个，不喜欢自己起一个";
        tipLabel.textColor = UIColorFromRGB(0xE96A79);
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        return oneView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.aType == AAccountType_NickName) {
        return 20;
    }
    return 0;
}

#pragma make - UI init
- (void)initGetCodeButton:(UIView *)view {
    UIButton *codeBtn = [[UIButton alloc] init];
    codeBtn.backgroundColor = UIColorFromRGB(0xE96A79);
    codeBtn.layer.cornerRadius = 8;
    [codeBtn setTitle:@"获取" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [codeBtn addTarget:self action:@selector(clickGetCode:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:codeBtn];
    self.codeButton = codeBtn;
    
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).mas_offset((view.frame.size.height-27)/2);
        make.right.mas_equalTo(view.mas_right).mas_offset(-10);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(27);
    }];
    
}

- (void)initUpdateHeadImageUrl {
    
    UIView *cameraBgView = [[UIView alloc] init];
    cameraBgView.backgroundColor = [UIColor blackColor];
    cameraBgView.alpha = .5;
    [_topImageView addSubview:cameraBgView];
    _topImageView.userInteractionEnabled = YES;
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [_topImageView addSubview:cameraButton];
    
    [cameraBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topImageView).mas_offset([ATools setViewFrameYForIPhoneX:80]);
        make.height.mas_offset(70.5);
        make.width.mas_offset(70.5);
        make.centerX.mas_equalTo(_topImageView);
    }];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topImageView).mas_offset([ATools setViewFrameYForIPhoneX:80]);
        make.height.mas_offset(70.5);
        make.width.mas_offset(70.5);
        make.centerX.mas_equalTo(_topImageView);
    }];
    
    [cameraBgView layoutIfNeeded];
    cameraBgView.layer.cornerRadius = cameraBgView.frame.size.height/2;
    cameraBgView.layer.borderColor = UIColorFromRGB(0xE96A79).CGColor;//UIColorFromRGB(0xE96A79).CGColor;
    cameraBgView.layer.borderWidth = 1;
}

- (void)loadUI {
    
    [self addSubview:self.aTableView];
    
    [self setupMakeTopViewSubViewsLayout];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomView).mas_offset(15);
        make.left.mas_equalTo(_bottomView).mas_offset(X_SPACE);
        make.right.mas_equalTo(_bottomView).mas_offset(-X_SPACE);
        make.height.mas_equalTo(44);
    }];
    if (self.aType == AAccountType_Login) {
        [self setupMakeBottomViewSubViewsLayout];
        [self setupButtonEdgeInsetsMake];
    } else if (self.aType == AAccountType_NickName) {
         [_logoImageView layoutIfNeeded];
        _logoImageView.clipsToBounds = YES;
        _logoImageView.layer.cornerRadius = _logoImageView.frame.size.height/2;
        _logoNameLabel.text = [AccountInfo getUserName];
        NSString * imageUrls = [[AccountInfo getUserHeadUrl] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrls]
                              placeholderImage:[UIImage imageNamed:@"public_logo"]];
        [self initUpdateHeadImageUrl];
    }
}

- (void)loadSubViewForFooter {
    [self.bottomView addSubview:self.otherView];
    [self.otherView addSubview:self.registerButton];
    [self.otherView addSubview:self.resetPsdButton];
    [self.otherView addSubview:self.thirdPartyView];
    [self.thirdPartyView addSubview:self.qqButton];
    [self.thirdPartyView addSubview:self.wecatButton];
    [self.thirdPartyView addSubview:self.weiboButton];
    //self.thirdPartyView.hidden = YES;
}

- (void)setupButtonEdgeInsetsMake {
    [ATools setButtonContentCenter:_qqButton];
    [ATools setButtonContentCenter:_wecatButton];
    [ATools setButtonContentCenter:_weiboButton];
}

- (void)setupMakeTopViewSubViewsLayout {
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topImageView).mas_offset([ATools setViewFrameYForIPhoneX:80]);
        make.height.mas_offset(70.5);
        make.width.mas_offset(70.5);
        make.centerX.mas_equalTo(_topImageView);
    }];
    [_logoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logoImageView.mas_bottom).mas_offset(1);
        make.left.mas_equalTo(_topImageView).mas_offset(0);
        make.right.mas_equalTo(_topImageView).mas_offset(0);
        make.bottom.mas_equalTo(_topImageView).mas_offset(-2);
    }];
}

- (void)setupMakeBottomViewSubViewsLayout {
    [_otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginButton.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(_bottomView).mas_offset(0);
        make.right.mas_equalTo(_bottomView).mas_offset(0);
        make.bottom.mas_equalTo(_bottomView).mas_offset(0);
    }];
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_otherView).mas_offset(15);
        make.left.mas_equalTo(_otherView.mas_left).mas_offset(X_SPACE);
        make.width.mas_equalTo(self.bottomView.frame.size.width/2-X_SPACE);
        make.height.mas_offset(28);
    }];
    
    [_resetPsdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_otherView).mas_offset(15);
        make.right.mas_equalTo(_otherView.mas_right).mas_offset(-X_SPACE);
        make.width.mas_equalTo(self.bottomView.frame.size.width/2-X_SPACE);
        make.height.mas_offset(28);
    }];
    
    [_thirdPartyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_otherView).mas_offset(0);
        make.top.mas_equalTo(_registerButton.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(_otherView.mas_bottom).mas_offset(0);
    }];
    [self setupMakeThirdParytViewSubViewsLayout];
}

- (void)setupMakeThirdParytViewSubViewsLayout {
    [_wecatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_thirdPartyView).mas_offset(60);
        make.centerX.mas_equalTo(_thirdPartyView);
        make.height.mas_offset(72);
        make.width.mas_offset(57);
    }];
    [_qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_thirdPartyView.mas_left).mas_offset(X_SPACE);
        make.top.mas_equalTo(_wecatButton);
        make.height.mas_offset(72);
        make.width.mas_offset(57);
    }];
    [_weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_thirdPartyView.mas_right).mas_offset(-X_SPACE);
        make.top.mas_equalTo(_wecatButton);
        make.height.mas_offset(72);
        make.width.mas_offset(57);
    }];
}
#pragma mark - 初始化UIKIT
- (UITableView *)aTableView {
    if (!_aTableView) {
        _aTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _aTableView.delegate = self;
        _aTableView.dataSource = self;
        _aTableView.scrollEnabled = NO;
        _aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _aTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _aTableView.tableHeaderView = self.topImageView;
        _aTableView.tableFooterView = self.bottomView;
    }
    return _aTableView;
}

- (UIImageView *)topImageView {
    if (_topImageView == nil) {
        CGFloat H = TopView_H;
        if (IS_IPHONE_X) {
            H = TopView_H + 20;
        }
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, H)];
        _topImageView.image = [UIImage imageNamed:@"public_head"];
        [_topImageView addSubview:self.logoImageView];
        [_topImageView addSubview:self.logoNameLabel];
    }
    return _topImageView;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"public_logo"];
    }
    return _logoImageView;
}

- (UILabel *)logoNameLabel {
    if (_logoNameLabel == nil) {
        _logoNameLabel = [[UILabel alloc] init];
        _logoNameLabel.text = @"加一次元";
        _logoNameLabel.textAlignment = NSTextAlignmentCenter;
        _logoNameLabel.textColor = [UIColor whiteColor];
        _logoNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _logoNameLabel;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat bottomH = self.aTableView.frame.size.height-TableViewCell_H*self.titleImages.count-TopView_H;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.aTableView.frame.size.width, bottomH)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.bottomView addSubview:self.loginButton];
        
        switch (self.aType) {
            case AAccountType_Login:
                [self loadSubViewForFooter];
                break;
            default:
                break;
        }

    }
    return _bottomView;
}

- (UIView *)otherView {
    if (_otherView == nil) {
        _otherView = [[UIView alloc] init];
        _otherView.backgroundColor = [UIColor whiteColor];
    }
    return _otherView;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.backgroundColor = UIColorFromRGB(0xE96A79);
        _loginButton.layer.cornerRadius = 15;
//        _loginButton.layer.borderColor = UIColorFromRGB(0xBAB8B9).CGColor;
//        _loginButton.layer.borderWidth = .5;
        [_loginButton setTitle:self.buttonTitle forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_loginButton addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [[UIButton alloc] init];
        _registerButton.backgroundColor = [UIColor whiteColor];
        [_registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_registerButton addTarget:self action:@selector(clickRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)resetPsdButton {
    if (_resetPsdButton == nil) {
        _resetPsdButton = [[UIButton alloc] init];
        _resetPsdButton.backgroundColor = [UIColor whiteColor];
        [_resetPsdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_resetPsdButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_resetPsdButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _resetPsdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_resetPsdButton addTarget:self action:@selector(clickResetPsd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetPsdButton;
}

- (UIView *)thirdPartyView {
    if (_thirdPartyView == nil) {
        _thirdPartyView = [[UIView alloc] init];
        _thirdPartyView.backgroundColor = [UIColor whiteColor];
    }
    return _thirdPartyView;
}

- (UIButton *)qqButton {
    if (_qqButton == nil) {
        _qqButton = [[UIButton alloc] init];
        _qqButton.backgroundColor = [UIColor whiteColor];
        [_qqButton setTitle:@"QQ登录" forState:UIControlStateNormal];
        [_qqButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_qqButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_qqButton setImage:[UIImage imageNamed:@"qq_icon"] forState:UIControlStateNormal];
        [_qqButton addTarget:self action:@selector(clickQQ:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqButton;
}

- (UIButton *)wecatButton {
    if (_wecatButton == nil) {
        _wecatButton = [[UIButton alloc] init];
        _wecatButton.backgroundColor = [UIColor whiteColor];
        [_wecatButton setTitle:@"微信登录" forState:UIControlStateNormal];
        [_wecatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wecatButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_wecatButton setImage:[UIImage imageNamed:@"wecat_icon"] forState:UIControlStateNormal];
        [_wecatButton addTarget:self action:@selector(clickWecat:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wecatButton;
}

- (UIButton *)weiboButton {
    if (_weiboButton == nil) {
        _weiboButton = [[UIButton alloc] init];
        _weiboButton.backgroundColor = [UIColor whiteColor];
        [_weiboButton setTitle:@"微博登录" forState:UIControlStateNormal];
        [_weiboButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_weiboButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_weiboButton setImage:[UIImage imageNamed:@"weibo_icon"] forState:UIControlStateNormal];
        [_weiboButton addTarget:self action:@selector(clickWeibo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weiboButton;
}

@end

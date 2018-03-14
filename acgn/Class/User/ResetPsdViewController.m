//
//  ResetPsdViewController.m
//  acgn
//
//  Created by Ares on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ResetPsdViewController.h"
#import "AccountView.h"
#import "SetPsdViewController.h"

@interface ResetPsdViewController ()<AccountViewDelegate>
@property (nonatomic, strong) AccountView *aView;

@end

@implementation ResetPsdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enable = YES;
    [self loadUI];
}

- (void)clickAccountSure:(id)sender datas:(NSMutableArray *)array {
    AccountLocalDataModel *phoneObj = [array firstObject];
    AccountLocalDataModel *codeObj = [array lastObject];
    if (STR_IS_NIL(phoneObj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入手机号码"];
        return;
    }
    if (STR_IS_NIL(codeObj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请填写验证码"];
        return;
    }
    if (phoneObj.content.length != 11) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入正确的手机号码"];
        return;
    }
    WS(weakSelf);
    [AApiModel getFindCodeConfirmSystem:phoneObj.content code:codeObj.content block:^(BOOL result) {
        if (result) {
            SetPsdViewController *setPsdVC = [[SetPsdViewController alloc] init];
            setPsdVC.phoneStr = phoneObj.content;
            [weakSelf.navigationController pushViewController:setPsdVC animated:YES];
        } else {
            
        }
    }];
}

- (void)clickGetCode:(id)sender obj:(AccountLocalDataModel *)obj {
    //WS(weakSelf);
    if (STR_IS_NIL(obj.content)) {
        return;
    }
    if (obj.content.length != 11) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入正确的手机号码"];
        return;
    }
    [AApiModel getFindCodeForPsdSystem:obj.content block:^(BOOL result) {
        if (result) {
            
        } else {
            
        }
    }];
}

#pragma mark -
#pragma mark - UI
- (void)loadUI {
    [self.view addSubview:self.aView];
}

- (AccountView *)aView {
    if (_aView == nil) {
        _aView = [[AccountView alloc] initWithFrame:self.view.bounds type:AAccountType_ResetPsd];
        _aView.delegate = self;
    }
    return _aView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
//    if (self.isThirdParty) {
//        self.title = @"设置密码";
//    }
    [self setNavigationBarTransparence:YES titleColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SetPsdViewController.m
//  acgn
//
//  Created by Ares on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "SetPsdViewController.h"
#import "AccountView.h"
#import "LoginViewController.h"
@interface SetPsdViewController ()<AccountViewDelegate>
@property (nonatomic, strong) AccountView *aView;

@end

@implementation SetPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"密码设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enable = YES;
    [self loadUI];
}

- (void)clickAccountSure:(id)sender datas:(NSMutableArray *)array {
    AccountLocalDataModel *psdObj0 = [array firstObject];
    AccountLocalDataModel *psdObj = [array lastObject];
    if (STR_IS_NIL(psdObj0.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请填写密码"];
        return;
    }
    if (STR_IS_NIL(psdObj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请填写密码"];
        return;
    }
    if (![psdObj0.content isEqualToString:psdObj.content]) {
        [ATools showSVProgressHudCustom:@"" title:@"两次密码不一致"];
        return;
    }
    if (psdObj0.content.length < 6 || psdObj0.content.length > 16) {
        [ATools showSVProgressHudCustom:@"" title:@"密码长度为6-16位"];
        return;
    }
    
    WS(weakSelf);
    [AApiModel getFindPsdForUserSystem:psdObj0.content phone:self.phoneStr block:^(BOOL result) {
        if (result) {
            NSInteger index = [weakSelf.navigationController.childViewControllers indexOfObject:weakSelf];
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.childViewControllers objectAtIndex:index-2] animated:YES];
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
        _aView = [[AccountView alloc] initWithFrame:self.view.bounds type:AAccountType_SetPsd];
        _aView.delegate = self;
    }
    return _aView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self setNavigationBarTransparence:YES titleColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

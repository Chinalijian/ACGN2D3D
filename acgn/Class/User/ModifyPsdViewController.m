//
//  ModifyPsdViewController.m
//  acgn
//
//  Created by lijian on 2018/2/5.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ModifyPsdViewController.h"
#import "AccountView.h"
@interface ModifyPsdViewController ()<AccountViewDelegate>
@property (nonatomic, strong) AccountView *aView;

@end

@implementation ModifyPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enable = YES;
    [self loadUI];
}

- (void)clickAccountSure:(id)sender datas:(NSMutableArray *)array {
    AccountLocalDataModel *psdObj = [array firstObject];
    AccountLocalDataModel *latestPsdObj1 = [array objectAtIndex:1];
    AccountLocalDataModel *latestPsdObj2 = [array lastObject];
    if (STR_IS_NIL(psdObj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入当前密码"];
        return;
    }
    if (STR_IS_NIL(latestPsdObj1.content) || STR_IS_NIL(latestPsdObj2.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入新密码"];
        return;
    }
    if (![latestPsdObj1.content isEqualToString:latestPsdObj2.content]) {
        [ATools showSVProgressHudCustom:@"" title:@"输入的新密码不一致"];
        return;
    }
    WS(weakSelf);
    [AApiModel modifyPsdForUser:psdObj.content latestPsd:latestPsdObj1.content block:^(BOOL result) {
        if (result) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
        _aView = [[AccountView alloc] initWithFrame:self.view.bounds type:AAccountType_ChangePsd];
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

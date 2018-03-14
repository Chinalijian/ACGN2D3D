//
//  RegisterViewController.m
//  acgn
//
//  Created by Ares on 2018/2/1.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "RegisterViewController.h"
#import "AccountView.h"
@interface RegisterViewController () <AccountViewDelegate>
@property (nonatomic, strong) AccountView *aView;

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isBindPhone) {
        self.title = @"绑定手机";
    } else {
        self.title = @"快速注册";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enable = YES;
    [self loadUI];
}

- (void)clickAccountSure:(id)sender datas:(NSMutableArray *)array {
    AccountLocalDataModel *phoneObj = [array firstObject];
    AccountLocalDataModel *codeObj = [array objectAtIndex:1];
    AccountLocalDataModel *psdObj = [array lastObject];
    
    if (STR_IS_NIL(phoneObj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请填写号码"];
        return;
    }
    if (STR_IS_NIL(codeObj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请填写验证码"];
        return;
    }
    if (STR_IS_NIL(psdObj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请填写密码"];
        return;
    }
    if (phoneObj.content.length != 11) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入正确的手机号码"];
        return;
    }
    if (psdObj.content.length < 6 || psdObj.content.length > 16) {
        [ATools showSVProgressHudCustom:@"" title:@"密码长度为6-16位"];
        return;
    }
    WS(weakSelf);
    
    if (self.isBindPhone) {
        [AApiModel bindPhoneForUser:phoneObj.content psd:psdObj.content code:codeObj.content block:^(BOOL result) {
            if (result) {
//                NSInteger index = [weakSelf.navigationController.childViewControllers indexOfObject:weakSelf];
//                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.childViewControllers objectAtIndex:index-2] animated:YES];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [AApiModel registerSystem:phoneObj.content psd:psdObj.content code:codeObj.content block:^(BOOL result) {
            if (result) {
                NSInteger index = [weakSelf.navigationController.childViewControllers indexOfObject:weakSelf];
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.childViewControllers objectAtIndex:index-2] animated:YES];
            }
        }];
    }
    
    
}

- (void)clickGetCode:(id)sender obj:(AccountLocalDataModel *)obj {
    //WS(weakSelf);
    if (STR_IS_NIL(obj.content)) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入手机号码"];
        return;
    }
    if (obj.content.length != 11) {
        [ATools showSVProgressHudCustom:@"" title:@"请输入正确的手机号码"];
        return;
    }
    
    if (self.isBindPhone) {
        [AApiModel bindPhoneCode:obj.content block:^(BOOL result) {
            if (result) {
                
            } else {
                
            }
        }];
    } else {
        [AApiModel getCodeForRegisterSystem:obj.content block:^(BOOL result) {
            if (result) {
                
            } else {
                
            }
        }];
    }
    
}

#pragma mark -
#pragma mark - UI
- (void)loadUI {
    [self.view addSubview:self.aView];
}

- (AccountView *)aView {
    if (_aView == nil) {
        if (self.isBindPhone) {
             _aView = [[AccountView alloc] initWithFrame:self.view.bounds type:AAccountType_BindPhone];
        } else {
             _aView = [[AccountView alloc] initWithFrame:self.view.bounds type:AAccountType_Register];
        }
       
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

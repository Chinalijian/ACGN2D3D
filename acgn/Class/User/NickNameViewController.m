//
//  NickNameViewController.m
//  acgn
//
//  Created by lijian on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "NickNameViewController.h"
#import "AccountView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface NickNameViewController ()<AccountViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) AccountView *aView;
@property (nonatomic, strong) CameraImageViewController *cameraImageVC;
@end
#define ORIGINAL_MAX_WIDTH [[UIScreen mainScreen] bounds].size.width
@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enable = YES;
    [self loadUI];
}

- (void)clickAccountSure:(id)sender datas:(NSMutableArray *)array {
    AccountLocalDataModel *obj = [array firstObject];
    WS(weakSelf);
    [AApiModel modifyNickNameForUser:obj.content block:^(BOOL result) {
        if (result) {
            [weakSelf.aView updateHeadUrlAndNickName];
            [ATools showSVProgressHudCustom:@"" title:@"修改成功"];
        }
    }];
}

- (void)modifyUserHeadImage:(UIImage *)image {
    WS(weakSelf);
    [AApiModel uploadHeadImageForUser:image block:^(BOOL result, NSString *imageUrl) {
        if (result) {
            if (!STR_IS_NIL(imageUrl)) {
                [AccountInfo saveUserHeadUrl:imageUrl];
                [weakSelf.aView updateHeadUrlAndNickName];
            }
            else {
                [ATools showSVProgressHudCustom:@"" title:@"修改失败"];
            }
        } else {
            [ATools showSVProgressHudCustom:@"" title:@"修改失败"];
        }
    }];
}

- (void)clickCameraForUser:(id)sender {
    WS(weakSelf);
    self.cameraImageVC = nil;
    self.cameraImageVC = [[CameraImageViewController alloc] initWithViewController:self isCropper:YES];
    __weak typeof(self) bself = self;
    
    [self.cameraImageVC configureCameraImageSuccessBlock:^(UIImage *headImage)
     {
         if (headImage)
         {
             [weakSelf modifyUserHeadImage:headImage];
         }
         else
         {
             //[MBProgressHUD hideAllHUDsForView:bself.view animated:YES];
             //失败
             bself.cameraImageVC = nil;
         }
     }];
    [self.cameraImageVC configureCameraImageCancleBlock:^(UIImage *headImage)
     {
         //[MBProgressHUD hideAllHUDsForView:bself.view animated:YES];
         bself.cameraImageVC = nil;
     }];

    //[self.aView updateHeadUrlAndNickName];
}

#pragma mark -
#pragma mark - UI
- (void)loadUI {
    [self.view addSubview:self.aView];
}

- (AccountView *)aView {
    if (_aView == nil) {
        _aView = [[AccountView alloc] initWithFrame:self.view.bounds type:AAccountType_NickName];
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

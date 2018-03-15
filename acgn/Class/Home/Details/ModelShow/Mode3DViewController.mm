//
//  Mode3DViewController.m
//  acgn
//
//  Created by Ares on 2018/3/13.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "Mode3DViewController.h"
#import "UnityController.h"
#import "ModeShowView.h"
#import "AppDelegate.h"
@interface Mode3DViewController () <ModeShowViewDelegate>
@property (nonatomic, strong) ModeShowView *msView;

@end

@implementation Mode3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.msView = [[ModeShowView alloc] initWithFrame:self.view.bounds];
    self.msView.delegate = self;
    [self.view addSubview:self.msView];
    [self loadNav];
    [self load3DMode];
}

- (void)loadNav {
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, [ATools getNavViewFrameHeightForIPhone])];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, [ATools setViewFrameYForIPhoneX:20], 64, 44);
    [backButton setImage:[UIImage imageNamed:@"public_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, backButton.frame.origin.y, DMScreenWidth-128, 44)];
    titleLabel.text = @"立体形象";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navView addSubview:titleLabel];
}

- (void)clickBackButton:(id)sender {
    [[UnityController instance] pauseUnity];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showWaitingPop {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];//背景颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

-(void)load3DMode {
    [self showWaitingPop];
    [APP_DELEGATE initUnityVC];
    [[UnityController instance] initUnity];
    [UnityController instance].playView.frame = self.msView.bounds;
    [self.msView addSubview:[UnityController instance].playView];
    [self.msView sendSubviewToBack:[UnityController instance].playView];
    [self performSelector:@selector(hiddenBgImage) withObject:nil afterDelay:2];
}

- (void)hiddenBgImage {
    [SVProgressHUD dismiss];
    self.msView.bgImageView.hidden = YES;
    self.msView.defaultShowImageView.hidden = YES;
}

- (void)clickModeShowButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1000:
            
            break;
        case 1001:
            
            break;
        case 1002:
            
            break;
        case 1003:
            
            break;
        case 2000://活动
            
            break;
        case 2001://福利
            
            break;
        case 2002://道具
            
            break;
        case 2003://信息
            
            break;
        case 3000://故事
            
            break;
        case 3001://动态
            
            break;
        case 3002://衣橱
            
            break;
        case 3003://任务
            
            break;
        default:
            break;
    }
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

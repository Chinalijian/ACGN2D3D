//
//  ModelShowViewController.m
//  acgn
//
//  Created by Ares on 2018/3/6.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ModelShowViewController.h"
//#import "IPhoneUtil.h"
//#import "LAppModel.h"
//#import "LAppDefine.h"
//#include "LAppLive2DManager.h"
#import <ZipArchive.h>
#import "ModelFileManager.h"
#import "Mode3DViewController.h"
#import "UnityController.h"
#import "ModeShowView.h"
#import "ACLive2DManager.h"
@interface ModelShowViewController () <ModeShowViewDelegate>
@property (nonatomic, strong) ModeShowView *msView;
@property (nonatomic, assign) Model_Show_Type type;
@end

@implementation ModelShowViewController
//{
//    LAppLive2DManager* live2DMgr;
//}

- (void)clickBackButton:(id)sender {
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"立体形象";
    if (!OBJ_IS_NIL(self.detailData)) {
        [ModelFileManager shareInstance].modelFilePathName = self.detailData.fileName;
        [ModelFileManager shareInstance].modefFileRoleID = self.detailData.roleId;
        [ModelFileManager shareInstance].modelFileShowJsonName = self.detailData.showJson;
        [ModelFileManager shareInstance].modefFileAllPath = [NSString stringWithFormat:@"%@/\%@/\%@", self.detailData.roleId,self.detailData.fileName, self.detailData.showJson];
        
        [self initSourceDataAndUI];
        [self loadNav];
        
        if (self.detailData.showType.integerValue == Model_Show_Type_2D) {
            self.type = Model_Show_Type_2D;
            [self downLoadModelFiles];

        } else {
            [self.msView.defaultShowImageView sd_setImageWithURL:[NSURL URLWithString:self.detailData.showUrl] placeholderImage:[UIImage imageNamed:@"default_model_Image"]];
            [self.msView.bottomProgressView setProgress:1 animated:YES];
        }
    }
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

- (void)initSourceDataAndUI {
    self.type = Model_Show_Type_Default;
    self.msView = [[ModeShowView alloc] initWithFrame:self.view.bounds];
    self.msView.delegate = self;
    [self.view addSubview:self.msView];
}

- (void)showWaitingPop {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];//背景颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

- (void)downLoadModelFiles {
    WS(weakSelf);
    
    NSString *tPath = [ATools getCachesHaveFile:[NSString stringWithFormat:@"%@/%@/%@", self.detailData.roleId, self.detailData.fileName, self.detailData.showJson]];
    BOOL isHave = [ATools fileExistsAtPathForLocal:tPath];
    if (isHave) {
//
//        // 处理耗时操作的代码块...
//        // 获取Documents目录
//        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        // 字典写入文件
//        // 创建一个存储字典的文件路径
//        NSString *fileDicPath = [docPath stringByAppendingPathComponent:[ModelFileManager shareInstance].modefFileAllPath];
//
//        NSData *data = [[NSData alloc] initWithContentsOfFile:fileDicPath];
//
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSMutableDictionary *mutResultDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
//        NSMutableDictionary *dicLayout = [resultDic objectForKey:@"layout"];
//        if (!OBJ_IS_NIL(dicLayout)) {
//            [dicLayout setObject:@"1.1" forKey:@"y"];
//            //[resultDic writeToFile:fileDicPath atomically:YES];
//        }
//
//
//
        [self load2DModelOr3DMoel];
        self.msView.bottomProgressView.progress = 1.0;
        return;
    }
    [self showWaitingPop];
    
    __weak __typeof(&*self.msView.bottomProgressView) weakProgressView = self.msView.bottomProgressView;
    [AApiModel downloadFileFromServer:self.detailData.showUrl fileName:self.detailData.fileName block:^(BOOL result, NSString *filePathUrl) {
        if (result) {
            NSString*unzipPath = [ATools autoUnZipFile:filePathUrl fileName:weakSelf.detailData.roleId];
            if (!STR_IS_NIL(unzipPath)) {

                dispatch_async(dispatch_get_global_queue(0, 0), ^{

                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [weakSelf load2DModelOr3DMoel];
                    });
                    
                });
                
          
            } else {
                [SVProgressHUD dismiss];
                [weakSelf performSelector:@selector(faileErrorShowModel) withObject:nil afterDelay:1];
            }
        } else {
            [SVProgressHUD dismiss];
            [weakSelf performSelector:@selector(faileErrorShowModel) withObject:nil afterDelay:1];
        }
    } progress:^(double fractionCompleted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"进度条进度更新");
            [weakProgressView setProgress:fractionCompleted animated:YES];
        });
        
    }];
}

- (void)load2DModelOr3DMoel {
    if (self.type == Model_Show_Type_2D) {
        [self loadLive2D];
    } else if (self.type == Model_Show_Type_3D) {
        
    }
    self.msView.bgImageView.hidden = YES;
    self.msView.defaultShowImageView.hidden = YES;
}

- (void)faileErrorShowModel {
    [ATools showSVProgressHudCustom:@"" title:@"加载失败"];
}

- (void)loadLive2D {
    // Live2Dを初期化
//    if (live2DMgr == nil) {
//        live2DMgr = new LAppLive2DManager();
//        CGRect screen = [IPhoneUtil getScreenRect];
//        LAppView* viewA = live2DMgr->createView(screen);
//        
//        live2DMgr->changeModel();
//        
//        UIView *liView = (UIView *)viewA;
//        // 画面に表示
//        [self.msView addSubview:liView];
//        
//        [self.msView sendSubviewToBack:liView];
//        
//        if (LAppDefine::DEBUG_LOG) NSLog(@"viewWillAppear @ViewController");
//        live2DMgr->onResume();
//    } else {
//        live2DMgr->update();
//    }
    
    [[ACLive2DManager shareInstance] loadLive2d:self.msView];
}

- (void)load3DModel {
    Mode3DViewController *mode3d = [[Mode3DViewController alloc] init];
    [self presentViewController:mode3d animated:NO completion:^{
    }];
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

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
//    if (self.type == Model_Show_Type_2D) {
//        if (live2DMgr == nil) {
//            return;
//        }
//        if (LAppDefine::DEBUG_LOG) NSLog(@"viewDidUnload @ViewController");
//        delete live2DMgr;
//        live2DMgr=nil;
//    }
    [super viewDidUnload];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    if (self.type == Model_Show_Type_2D) {
//        if (live2DMgr == nil) {
//            return;
//        }
//        if (LAppDefine::DEBUG_LOG) NSLog(@"viewWillDisappear @ViewController");
//        live2DMgr->onPause();
//    }

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setNavigationBarTransparence:YES titleColor:[UIColor whiteColor]];
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


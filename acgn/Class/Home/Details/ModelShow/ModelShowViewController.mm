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
#import "AppDelegate.h"
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
            WS(weakSelf);
//            [self.msView.defaultShowImageView sd_setImageWithURL:[NSURL URLWithString:self.detailData.showUrl] placeholderImage:[UIImage imageNamed:@"default_model_Image"]];
            [DMActivityView showActivity:self.view];
            NSString * imageUrl = [self.detailData.showUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self.msView.defaultShowImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [DMActivityView hideActivity];
                if (image) {
                    weakSelf.msView.defaultShowImageView.image = image;
                } else {
                    weakSelf.msView.defaultShowImageView.image = [UIImage imageNamed:@"default_model_Image"];
                }
            }];
            
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
        [self modifyJsonContent:tPath];
        [self load2DModelOr3DMoel];
        self.msView.bottomProgressView.progress = 1.0;
        return;
    }
    //[self showWaitingPop];
    [DMActivityView showActivity:self.view];
    __weak __typeof(&*self.msView.bottomProgressView) weakProgressView = self.msView.bottomProgressView;
    [AApiModel downloadFileFromServer:self.detailData.showUrl fileName:self.detailData.fileName block:^(BOOL result, NSString *filePathUrl) {
        if (result) {
            NSString*unzipPath = [ATools autoUnZipFile:filePathUrl fileName:weakSelf.detailData.roleId];
            if (!STR_IS_NIL(unzipPath)) {

                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [weakSelf modifyJsonContent:tPath];
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[SVProgressHUD dismiss];
                        [DMActivityView hideActivity];
                        [weakSelf load2DModelOr3DMoel];
                    });
                    
                });
                
          
            } else {
                //[SVProgressHUD dismiss];
                [DMActivityView hideActivity];
                [weakSelf performSelector:@selector(faileErrorShowModel) withObject:nil afterDelay:1];
            }
        } else {
            //[SVProgressHUD dismiss];
            [DMActivityView hideActivity];
            [weakSelf performSelector:@selector(faileErrorShowModel) withObject:nil afterDelay:1];
        }
    } progress:^(double fractionCompleted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"进度条进度更新");
            [weakProgressView setProgress:fractionCompleted animated:YES];
        });
        
    }];
}

- (void)modifyJsonContent:(NSString *)filePath {
    if (IS_IPHONE_X) {
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSMutableDictionary *modifyDic = [resultDic objectForKey:@"layout"];
        NSNumber *yValue = [modifyDic objectForKey:@"y"];
        if ([yValue doubleValue] != 1.05) {
            [modifyDic setValue:[NSNumber numberWithDouble:1.05] forKey:@"y"];
            NSError *error;
            NSData *resultData = [NSJSONSerialization dataWithJSONObject:resultDic options:kNilOptions error:&error];
            NSString *resultJsonString =[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            //[resultJsonString writeToFile:filePath atomically:YES];
            resultJsonString = [resultJsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
            
            [resultJsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
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
    [[ACLive2DManager shareInstance] loadLive2d:self.msView];
}

- (void)load3DModel {

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


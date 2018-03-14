//
//  DMHttpClient.m
//  acgn
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMHttpClient.h"
#import "DMRequestModel.h"

#import <objc/objc.h>
#import <objc/runtime.h>

@implementation DMHttpClient

#define Data_Key @"data"
#define Code_Key @"code"
#define Msg_Key @"msg"
#define Token_Key @"token"
#define Time_Key @"time"

+ (DMHttpClient *)sharedInstance {
    static DMHttpClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

-(void)initWithUrl:(NSString*)url
      parameters:(NSMutableDictionary*)parameters
          method:(DMHttpRequestType)requestMethod
  dataModelClass:(Class)dataModelClass
     isMustToken:(BOOL)mustToken
         success:(void (^)(id responseObject))success
         failure:(void (^)( NSError *error))failure {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (OBJ_IS_NIL(parameters)) {
        dic = [self fixedParameters:[NSMutableDictionary dictionary]];
    } else {
        dic = [self fixedParameters:parameters];
    }
    
    [[DMRequestModel sharedInstance] requestWithPath:url method:requestMethod parameters:dic prepareExecute:^{
        
    } success:^(id responseObject) {
       
        id responseObj = responseObject;
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"返回的数据 = %@",responseObj);
        if (OBJ_IS_NIL(responseObj)) {
            [ATools showSVProgressHudCustom:@"hud_failed_icon" title:@"未知错误"];
            success(nil);
            return;
        }
        
        if ([[responseObj objectForKey:@"code"] intValue] == DMHttpResponseCodeType_Success) {
            if ([dataModelClass isEqual:[PraiseDataModel class]]) {
                id responseDataModel = [dataModelClass mj_objectWithKeyValues:responseObj];
                success(responseDataModel);
            } else {
                id dataType = [responseObj objectForKey:Data_Key];
                if ([dataType isKindOfClass:[NSArray class]]) {
                    id responseDataModel = [dataModelClass mj_objectWithKeyValues:responseObj];
                    success(responseDataModel);
                } else {
                    id responseDataModel = [dataModelClass mj_objectWithKeyValues:[responseObj objectForKey:Data_Key]];
                    success(responseDataModel);
                }
            }

        } else if ([[responseObj objectForKey:@"code"] intValue] == 1021 || [[responseObj objectForKey:@"code"] intValue] == 1022) {
            success([responseObj objectForKey:@"msg"]);
        } else {
            if ([[responseObj objectForKey:Msg_Key] isKindOfClass:[NSString class]]) {
                [self responseStatusCodeException:[[responseObj objectForKey:Code_Key] intValue]
                                              msg:[responseObj objectForKey:Msg_Key]];
            } else {
                [self responseStatusCodeException:[[responseObj objectForKey:Code_Key] intValue]
                                              msg:@"未知错误"];
            }
            
            failure(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求错误信息 = %@", error);
        self.blockSuccessMsg = nil;
        [ATools showSVProgressHudCustom:@"" title:@"网络连接错误"];
        failure(error);
    }];
}

-(void)initWithUrlForLog:(NSString*)url
              parameters:(NSMutableDictionary*)parameters
                  method:(DMHttpRequestType)requestMethod
                 success:(void (^)(id responseObject))success
                 failure:(void (^)( NSError *error))failure
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (OBJ_IS_NIL(parameters)) {
        dic = [self fixedParameters:[NSMutableDictionary dictionary]];
    } else {
        dic = [self fixedParameters:parameters];
    }
    [[DMRequestModel sharedInstance] requestWithPath:url method:requestMethod parameters:dic prepareExecute:nil success:nil failure:nil];
}

-(void)didSuccessMsg:(BlockSuccessMsg)blockSuccessMsg {
    self.blockSuccessMsg = blockSuccessMsg;
}

- (NSMutableDictionary *)fixedParameters:(NSMutableDictionary *)source {
//    [source setObject:App_Version forKey:@"ver"];
//    [source setObject:App_Type forKey:@"app"];
//    [source setObject:STR_IS_NIL([DMAccount getToken]) ? @"": [DMAccount getToken] forKey:@"token"];
    return source;
}

- (void)responseStatusCodeException:(NSInteger)code msg:(NSString *)message {
    self.blockSuccessMsg = nil;
    switch (code) {
        case DMHttpResponseCodeType_NotLogin: //未登录，需要重新登录
            [self logoutToLoginPage:@""];
            break;
        case DMHttpResponseCodeType_Failed:
            if ([message isKindOfClass:[NSString class]]) {

                [ATools showSVProgressHudCustom:@"hud_failed_icon" title:message];
            } else {
                [ATools showSVProgressHudCustom:@"hud_failed_icon" title:@"未知错误"];
            }
            break;
        case DMHttpResponseCodeType_MustLogout:
            [self logoutToLoginPage:message];
            //[self showAlertLogout:message];
            break;
        default:
            if ([message isKindOfClass:[NSString class]]) {
                [ATools showSVProgressHudCustom:@"" title:message];
            } else {
                [ATools showSVProgressHudCustom:@"" title:@"未知错误"];
            }
            break;
    }
}

- (void)logoutToLoginPage:(NSString *)msg {
    //to-do 1，取消所有网络请求，2，清除用户所有信息，3，退到登录界面
 
}

- (void)showAlertLogout:(NSString *)msg {
//    DMAlertMananger *alert = [DMAlertMananger shareManager];
//
//    [alert creatAlertWithTitle:@""
//                       message:msg
//                preferredStyle:UIAlertControllerStyleAlert
//                   cancelTitle:DMTitleOK
//                    otherTitle:nil];
//    [alert showWithViewController:APP_DELEGATE.window.rootViewController IndexBlock:nil];
}

/**
 * 同步请求
 */
-(void)synRequestWithUrl:(NSString *)synUrl
          dataModelClass:(Class)dataModelClass
             isMustToken:(BOOL)mustToken
                 success:(void (^)(id responseObject))success
                 failure:(void (^)( NSError *error))failure
{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    NSURL *url = [NSURL URLWithString:synUrl];
    
    //2.构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //(1)设置为POST请求
    [request setHTTPMethod:@"POST"];
    
    //(2)超时
    [request setTimeoutInterval:10];
    
    //(3)设置请求头
    //[request setAllHTTPHeaderFields:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //(4)设置请求体
    //NSString *bodyStr = @"user_name=admin&user_password=admin";
    //NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [self fixedParameters:[NSMutableDictionary dictionary]];
    //设置请求体
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil]];
    
    //3.构造Session
    NSURLSession *session = [NSURLSession sharedSession];
    __block id responseDataModel = nil;
    __block BOOL isSuc = NO;
    //4.task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!OBJ_IS_NIL(data)) {
            isSuc = YES;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"dict:%@",dict);
            responseDataModel = [dataModelClass mj_objectWithKeyValues:[dict objectForKey:Data_Key]];
        }
        dispatch_semaphore_signal(semaphore);   //发送信号
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    NSLog(@"数据加载完成！");
    if (isSuc) {
        success(responseDataModel);
    } else {
        NSLog(@"失败了");
        failure(nil);
    }
}

- (void)downLoadFileRequest:(NSURL *)fileUrl fileName:(NSString *)fileName
                    success:(void (^)(id responseObject))success
                    failure:(void (^)( NSError *error))failure
                    progress:(void (^)(double fractionCompleted))progressDownload {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"下载进度 = %f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        NSLog(@"下载进度：%f", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        progressDownload(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
         NSLog(@"下载完成");
        if (error != nil) {
            failure(error);
        } else {
            success(filePath);
        }
    }];
    [downloadTask resume];
}

- (void)reachabilityNetworkStatus {
    /* 监听网络状态 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            NSLog(@"当前网络：未知网络");
        } else if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"当前网络：没有网络");
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            NSLog(@"当前网络：手机流量");
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"当前网络：WiFi");
        }
    }];
    [manager startMonitoring];
}

- (void)cancleAllHttpRequestOperations {
    [[DMRequestModel sharedInstance] cancleAllHttpRequestOperations];
}

- (void)updateTokenToLatest:(NSString *)token {
    //[DMCommonModel updateFailureToken:token];
}

//请求合法性校验
-(BOOL)isRequestValid {
    return YES;
}

@end

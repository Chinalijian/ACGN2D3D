//
//  ShareManage.m
//  ShareSDK_Demo
//
//  Created by LIJIAN on 16/2/2.
//  Copyright © 2016年 LIJIAN. All rights reserved.
//

#import "ShareManage.h"
#import <UMSocialCore/UMSocialCore.h>
@implementation UMShareDataModel

@end


@implementation ShareManage

//字符串非空判断宏定义
#define STR_IS_NIL(key) (([@"<null>" isEqualToString:(key)] || [@"" isEqualToString:(key)] || key == nil || [key isKindOfClass:[NSNull class]]) ? 1: 0)
#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])
#define STR_DEFAULT_LINK @"http://www.shiku.com"
#define STR_DEFAULT_IMAGENAME @"xxx.png"

static ShareManage* _instance = nil;

NSString *const SK_ShareToSina                      = @"sina";
NSString *const SK_ShareToWechatSession             = @"session";
NSString *const SK_ShareToWechatTimeline            = @"timeline";
NSString *const SK_ShareToWechatFavorite            = @"favorite";
NSString *const SK_ShareToQQ                        = @"qq";
NSString *const SK_ShareToQzone                     = @"qzone";

- (void)initThirdPartyInfo {
    /* 设置友盟appkey */
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5a8416f7f29d985c430004cd"];
    [self configUSharePlatforms];
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxe8092a7cdf9e6cb1" appSecret:@"af138a2246e2f4840bce1cc01d9c1e1f" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106601204"/*设置QQ平台的appID*/  appSecret:@"OIO9CvvRTGFnmiB6" redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3397669787"  appSecret:@"0b50ce4eb8097880bafb826dd8525b7d" redirectURL:@"http://www.sharesdk.cn"];
 
}



+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [ShareManage shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [ShareManage shareInstance];
}

@end

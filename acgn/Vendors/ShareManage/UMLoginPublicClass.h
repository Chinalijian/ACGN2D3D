//
//  UMLoginPublicClass.h
//  YMShareDemo_2
//
//  Created by 许俊全 on 15/3/16.
//  Copyright (c) 2015年 iosTeam. All rights reserved.
//
/*
 如果qq登陆 不进入手机qq，请检查url设置是否正确，根据友盟说明文档，需要两个url
 http://dev.umeng.com/social/ios/detail-share#5
 */

#import <Foundation/Foundation.h>
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
//#import "UMSocialSnsPlatformManager.h"

typedef void(^LoginInfoBlock)(NSDictionary *info);

@interface UMLoginPublicClass : NSObject
//使用第三方软件账号登陆
+ (void)loginWithThirdPlat:(UMSocialPlatformType)platformType andLoginCtr:(UIViewController *)ctr andLoginInfo:(LoginInfoBlock)loginInfoBlock;
//解除授权
+ (void)deleteOauthWithThirdPlat:(NSString *)plat;

@end

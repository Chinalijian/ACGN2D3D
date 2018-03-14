//
//  UMLoginPublicClass.m
//  YMShareDemo_2
//
//  Created by 许俊全 on 15/3/16.
//  Copyright (c) 2015年 iosTeam. All rights reserved.
//

#import "UMLoginPublicClass.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMSocialCore/UMSocialPlatformConfig.h>
@implementation UMLoginPublicClass

+ (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType {
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        
    }];
}

+ (void)loginWithThirdPlat:(UMSocialPlatformType)platformType andLoginCtr:(UIViewController *)ctr andLoginInfo:(LoginInfoBlock)loginInfoBlock{
    
    [UMLoginPublicClass cancelAuthWithPlatform:platformType];

    [[UMSocialManager defaultManager] authWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (!error) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            UMSocialUserInfoResponse *resp = result;
            switch (platformType) {
                case UMSocialPlatformType_Sina:
                    [dic setValue:resp.uid forKey:@"uid"];
                    [dic setValue:resp.accessToken forKey:@"access_token"];
                    break;
                case UMSocialPlatformType_QQ:
                    [dic setValue:resp.openid forKey:@"open_id"];
                    [dic setValue:resp.accessToken forKey:@"access_token"];
                    break;
                case UMSocialPlatformType_WechatSession:
                    [dic setValue:resp.openid forKey:@"open_id"];
                    [dic setValue:resp.accessToken forKey:@"access_token"];
                    break;
                default:
                    break;
            }
            
            loginInfoBlock(dic);
            
            // 第三方登录数据(为空表示平台未提供)
            // 授权数据
//            NSLog(@" uid: %@", resp.uid);
//            NSLog(@" openid: %@", resp.openid);
//            NSLog(@" accessToken: %@", resp.accessToken);
//            NSLog(@" refreshToken: %@", resp.refreshToken);
//            NSLog(@" expiration: %@", resp.expiration);
//            
//            
//            NSLog(@"Wechat unionid: %@", resp.unionId);
            
            
//            // 用户数据
//            NSLog(@" name: %@", resp.name);
//            NSLog(@" iconurl: %@", resp.iconurl);
//            NSLog(@" gender: %@", resp.unionGender);
//            
//            // 第三方平台SDK原始数据
//            NSLog(@" originalResponse: %@", resp.originalResponse);
//            
            
        } else {
            //登陆失败
            loginInfoBlock(nil);
        }
        
    }];
}

+ (void)deleteOauthWithThirdPlat:(NSString *)plat{
//    if ([[UMSocialData defaultData].socialAccount objectForKey:plat] != nil){
//        [[UMSocialDataService defaultDataService] requestUnOauthWithType:plat completion:^(UMSocialResponseEntity *response){
//            NSLog(@"response is %@",response);
//        }];
//    }
}

@end




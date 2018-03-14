//
//  ShareManage.h
//  ShareSDK_Demo
//
//  Created by LIJIAN on 16/2/2.
//  Copyright © 2016年 LIJIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialPlatformConfig.h>
//#import "UMSocialSnsPlatformManager.h"

@interface UMShareDataModel : NSObject
//分享参数
@property(nonatomic, strong) NSString *shareTitle;
@property(nonatomic, strong) NSString *shareText;
@property(nonatomic, strong) NSString *shareNetImgUrl;
@property(nonatomic, strong) id shareLocalImg;
@property(nonatomic, strong) NSString *shareLinkUrl;
@end

@interface ShareManage : NSObject

+ (instancetype)shareInstance;
- (void)initThirdPartyInfo;

@end





























































































///**
// 邮箱
// */
//extern NSString *const SK_ShareToEmail;
///**
// 短信
// */
//extern NSString *const SK_ShareToSms;
///**
// 腾讯微博
// */
//extern NSString *const SK_ShareToTencent;
//
///**
// 人人网
// */
//extern NSString *const SK_ShareToRenren;
//
///**
// 豆瓣
// */
//extern NSString *const SK_ShareToDouban;
///**
// 支付宝好友
// */
//extern NSString *const SK_ShareToAlipaySession;
//
///**
// Facebook
// */
//extern NSString *const SK_ShareToFacebook;
//
///**
// Twitter
// */
//extern NSString *const SK_ShareToTwitter;
//
///**
// 易信好友
// */
//extern NSString *const SK_ShareToYXSession;
//
///**
// 易信朋友圈
// */
//extern NSString *const SK_ShareToYXTimeline;
//
///**
// 来往好友
// */
//extern NSString *const SK_ShareToLWSession;
//
///**
// 来往朋友圈
// */
//extern NSString *const SK_ShareToLWTimeline;


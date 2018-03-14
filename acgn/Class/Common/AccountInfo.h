//
//  AccountInfo.h
//  acgn
//
//  Created by lijian on 2018/2/3.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject

//读取账号信息
+ (id)getAccountInfo;

//读取用户姓名
+ (NSString *)getUserName;
//读取用户头像
+ (NSString *)getUserHeadUrl;
//读取uid
+ (NSString *)getUserID;
//读取phone
+ (NSString *)getUserPhone;
//是否有关注
+ (NSString *)getHasFollowStatus;

//保存账号信息
+ (void)saveAccountInfo:(UserDataModel *)obj;
//保存用户姓名
+ (void)saveUserName:(NSString *)name;
//保存用户头像
+ (void)saveUserHeadUrl:(NSString *)headUrl;
//保存phone
+ (void)saveUserPhone:(NSString *)phone;
//保存用户uid
+ (void)saveUserID:(NSString *)uID;
//保存是否关注了
+ (void)saveUserHasFollow:(NSString *)has;

//清除用户所有信息
+ (void)removeUserAllInfo;

@end

//
//  AccountInfo.m
//  acgn
//
//  Created by lijian on 2018/2/3.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "AccountInfo.h"
#import "DMUserDefaults.h"

@implementation AccountInfo

#define U_NAME @"userName"
#define U_FOLLOW @"hasFollow"
#define U_AVATAR @"avatar"
#define U_PHONE @"phone"
#define U_UID @"uid"
//读取账号信息
+ (UserDataModel *)getAccountInfo {
    UserDataModel *model = [[UserDataModel alloc] init];
    model.phone = [AccountInfo getUserPhone];
    model.userName = [AccountInfo getUserName];
    model.avatar = [AccountInfo getUserHeadUrl];
    model.uid = [AccountInfo getUserID];
    model.hasFollow = [AccountInfo getHasFollowStatus];
    return model;
}

//读取用户姓名
+ (NSString *)getUserName {
    return [DMUserDefaults getValueWithKey:U_NAME];
}

//读取用户头像
+ (NSString *)getUserHeadUrl {
    return [DMUserDefaults getValueWithKey:U_AVATAR];
}

//读取uid
+ (NSString *)getUserID {
    return STR_IS_NIL([DMUserDefaults getValueWithKey:U_UID])?@"":[DMUserDefaults getValueWithKey:U_UID] ;
}

//读取phone
+ (NSString *)getUserPhone {
    return STR_IS_NIL([DMUserDefaults getValueWithKey:U_PHONE])?@"":[DMUserDefaults getValueWithKey:U_PHONE] ;
}

//读取是否有关注
+ (NSString *)getHasFollowStatus {
    return [DMUserDefaults getValueWithKey:U_FOLLOW];
}

//保存账号信息
+ (void)saveAccountInfo:(UserDataModel *)obj {
    if (OBJ_IS_NIL(obj)) {
        return;
    }
    [AccountInfo saveUserName:obj.userName];
    [AccountInfo saveUserHeadUrl:obj.avatar];
    [AccountInfo saveUserPhone:obj.phone];
    [AccountInfo saveUserID:obj.uid];
    [AccountInfo saveUserHasFollow:obj.hasFollow];
}

//保存用户姓名
+ (void)saveUserName:(NSString *)name {
    [DMUserDefaults setValue:name forKey:U_NAME];
}

//保存用户头像
+ (void)saveUserHeadUrl:(NSString *)headUrl {
    [DMUserDefaults setValue:headUrl forKey:U_AVATAR];
}

//保存用户uid
+ (void)saveUserID:(NSString *)uID {
    [DMUserDefaults setValue:uID forKey:U_UID];
}

//保存phone
+ (void)saveUserPhone:(NSString *)phone {
    [DMUserDefaults setValue:phone forKey:U_PHONE];
}

//保存是否关注了
+ (void)saveUserHasFollow:(NSString *)has {
    [DMUserDefaults setValue:has forKey:U_FOLLOW];
}

//清除用户所有信息
+ (void)removeUserAllInfo {

    [AccountInfo saveUserID:@""];
    [AccountInfo saveUserName:@""];
    [AccountInfo saveUserHeadUrl:@""];
    [AccountInfo saveUserPhone:@""];
    [AccountInfo saveUserHasFollow:@""];
}

@end

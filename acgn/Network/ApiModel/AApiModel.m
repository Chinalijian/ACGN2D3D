//
//  AApiModel.m
//  acgn
//
//  Created by Ares on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "AApiModel.h"
#import "DMHttpClient.h"

@implementation AApiModel
//登录
+ (void)loginSystem:(NSString *)account psd:(NSString *)password block:(void(^)(BOOL result))block {
    
    NSString *psdStr = [ATools MD5:password];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:account, @"phone", psdStr, @"passWord",nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_User_Loing_Url parameters:dic method:DMHttpRequestPost dataModelClass:[UserDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            //保存数据
            UserDataModel *model = (UserDataModel *)responseObject;
            [AccountInfo saveAccountInfo:model];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//注册
+ (void)registerSystem:(NSString *)account psd:(NSString *)password code:(NSString *)code block:(void(^)(BOOL result))block {
    NSString *psdStr = [ATools MD5:password];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:account, @"phone", psdStr, @"passWord", code, @"code", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_User_Register_Url parameters:dic method:DMHttpRequestPost dataModelClass:[UserDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            //保存数据
            UserDataModel *model = (UserDataModel *)responseObject;
            [AccountInfo saveAccountInfo:model];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//获取验证码
+ (void)getCodeForRegisterSystem:(NSString *)phone block:(void(^)(BOOL result))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone, @"phone", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Register_Code_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//获取找回密码验证码
+ (void)getFindCodeForPsdSystem:(NSString *)phone block:(void(^)(BOOL result))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone, @"phone", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Find_Psd_Code_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//获取找回密码验证码
+ (void)getFindCodeConfirmSystem:(NSString *)phone code:(NSString *)code block:(void(^)(BOOL result))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone, @"phone", code, @"verCode",nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Confirm_Code_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//确认找回密码
+ (void)getFindPsdForUserSystem:(NSString *)psd phone:(NSString *)phone block:(void(^)(BOOL result))block {
    NSString *psdStr = [ATools MD5:psd];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:psdStr, @"password", phone, @"phone",nil];
    NSLog(@"参数 = %@", dic);
    [[DMHttpClient sharedInstance] initWithUrl:DM_FindPassWord_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
    
}
//修改密码
+ (void)modifyPsdForUser:(NSString *)psd latestPsd:(NSString *)latestPsd block:(void(^)(BOOL result))block {
    NSString *uID = [AccountInfo getUserID];
    NSString *psdStr = [ATools MD5:psd];
    NSString *latestPsdStr = [ATools MD5:latestPsd];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:uID, @"uId", psdStr, @"password", latestPsdStr, @"newPassWord",nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Modify_Psd_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//修改昵称
+ (void)modifyNickNameForUser:(NSString *)nickName block:(void(^)(BOOL result))block {
    NSString *uID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:uID, @"uid", nickName, @"userName", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Modify_NickName_Url parameters:dic method:DMHttpRequestPost dataModelClass:[UserDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            UserDataModel *model = (UserDataModel *)responseObject;
            [AccountInfo saveUserName:model.userName];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//获取首页角色列表
+ (void)getRoleListForHome:(NSString *)lastID block:(void(^)(BOOL result, NSArray *array))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastID, @"lastId", @"20", @"rowPage", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Role_List_Url parameters:dic method:DMHttpRequestPost dataModelClass:[PeopleListDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            PeopleListDataModel *model = (PeopleListDataModel *)responseObject;
            block(YES, model.data);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//首页关注
+ (void)getHomeAttentList:(NSString *)lastId block:(void(^)(BOOL result, NSArray *array))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastId, @"lastId", @"20", @"rowPage", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_FollowHome_Url parameters:dic method:DMHttpRequestPost dataModelClass:[DynamicData class] isMustToken:NO success:^(id responseObject) {
        
        if (!OBJ_IS_NIL(responseObject)) {
            if (![responseObject isKindOfClass:[NSString class]]) {
                DynamicData *model = (DynamicData *)responseObject;
                block(YES, model.data);
            } else {
                [ATools showSVProgressHudCustom:@"" title:(NSString *)responseObject];
                block(YES, nil);
            }
        } else {
            [ATools showSVProgressHudCustom:@"" title:@"暂无关注"];
           block(YES, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//首页广场
+ (void)getHomePostList:(NSString *)lastId block:(void(^)(BOOL result, NSArray *array))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastId, @"lastId", @"20", @"rowPage", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_HomePost_Url parameters:dic method:DMHttpRequestPost dataModelClass:[DynamicData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            DynamicData *model = (DynamicData *)responseObject;
            block(YES, model.data);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}
//获取最新的帖子
+ (void)getLatestPostContent:(NSString *)type indexId:(NSString *)indexID block:(void(^)(BOOL result, RefreshDataSubModel *obj))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:indexID, @"indexId", @"20", @"rowPage", userID, @"uId", type, @"type", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Latest_Post_Url parameters:dic method:DMHttpRequestPost dataModelClass:[RefreshDataSubModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            RefreshDataSubModel *model = (RefreshDataSubModel *)responseObject;
            block(YES, model);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}
//获取动态详情
+ (void)getPostDetilsData:(NSString *)postId block:(void(^)(BOOL result, DynamicListData *obj))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:postId, @"postId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_GetPostDetails_Url parameters:dic method:DMHttpRequestPost dataModelClass:[DynamicListData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            DynamicListData *model = (DynamicListData *)responseObject;
            block(YES, model);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//获取动态评论列表
+ (void)getPostCommentListData:(NSString *)postId lastId:(NSString *)lastId block:(void(^)(BOOL result, NSArray *array))block {
    NSString *userID = [AccountInfo getUserID];
    NSLog(@"POST ID = %@",lastId);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:postId, @"postId", lastId, @"lastId", userID, @"uId", @"10", @"rowPage", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_GetPostComment_List_Url parameters:dic method:DMHttpRequestPost dataModelClass:[DynamicDetailsCommentData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            DynamicDetailsCommentData *model = (DynamicDetailsCommentData *)responseObject;
            block(YES, model.data);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}
//个人详情里 人物发的帖子列表
+ (void)getRoleDtailsListData:(NSString *)roleId lastId:(NSString *)lastId block:(void(^)(BOOL result, NSArray *array))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:roleId, @"roleId", lastId, @"lastId", @"10", @"rowPage", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_GetRoleDetails_List_Url parameters:dic method:DMHttpRequestPost dataModelClass:[RoleDetailsPostListData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            RoleDetailsPostListData *model = (RoleDetailsPostListData *)responseObject;
            block(YES, model.data);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//个人详情人物信息
+ (void)getRoleInfoData:(NSString *)roleId block:(void(^)(BOOL result, RoleDetailsDataModel *obj))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:roleId, @"roleId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_GetRoleInfoDetails_Url parameters:dic method:DMHttpRequestPost dataModelClass:[RoleDetailsDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            RoleDetailsDataModel *model = (RoleDetailsDataModel *)responseObject;
            block(YES, model);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//吐槽中心
+ (void)getGetCommentDetailsData:(NSString *)commentId lastId:(NSString *)lastId block:(void(^)(BOOL result, MsgCommitData *obj))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:commentId, @"commentId", lastId, @"lastId", @"10", @"rowPage", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_GetCommentDetails_Url parameters:dic method:DMHttpRequestPost dataModelClass:[MsgCommitData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            MsgCommitData *model = (MsgCommitData *)responseObject;
            block(YES, model);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//收藏
+ (void)addCollectionForUser:(NSString *)postId roleId:(NSString *)roleId block:(void(^)(BOOL result))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:postId, @"postId", userID, @"uId", roleId, @"roleId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Add_Collection_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}

//取消收藏
+ (void)delCollectionForUser:(NSString *)postId block:(void(^)(BOOL result))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:postId, @"postId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Del_Collection_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}

//点赞-帖子
+ (void)addFabulousForUser:(NSString *)postId block:(void(^)(BOOL result, NSString * praiseNum))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:postId, @"postId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Add_Fabulous_Url parameters:dic method:DMHttpRequestPost dataModelClass:[PraiseDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            PraiseDataModel *data = (PraiseDataModel *)responseObject;
            block(YES, data.data);
        } else {
            block(NO, @"-1");
        }
    } failure:^(NSError *error) {
        block (NO, @"-1");
    }];
}

//取消点赞-帖子
+ (void)delFabulousForUser:(NSString *)postId block:(void(^)(BOOL result, NSString * praiseNum))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:postId, @"postId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Del_Fabulous_Url parameters:dic method:DMHttpRequestPost dataModelClass:[PraiseDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            PraiseDataModel *data = (PraiseDataModel *)responseObject;
            block(YES, data.data);
        } else {
            block(NO, @"-1");
        }
    } failure:^(NSError *error) {
        block (NO, @"-1");
    }];
}

//点赞-评论
+ (void)addPraiseForUser:(NSString *)postId commentId:(NSString *)commentId block:(void(^)(BOOL result ,NSString *praiseNum))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:commentId, @"commentId", postId, @"postId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Add_Praise_Url parameters:dic method:DMHttpRequestPost dataModelClass:[PraiseDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            PraiseDataModel *data = (PraiseDataModel *)responseObject;
            block(YES, data.data);
        } else {
            block(NO, @"-1");
        }
    } failure:^(NSError *error) {
        block (NO, @"-1");
    }];
}

//取消点赞-评论
+ (void)delPraiseForUser:(NSString *)postId commentId:(NSString *)commentId block:(void(^)(BOOL result,NSString *praiseNum))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:commentId, @"commentId", postId, @"postId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Del_Praise_Url parameters:dic method:DMHttpRequestPost dataModelClass:[PraiseDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            PraiseDataModel *data = (PraiseDataModel *)responseObject;
            block(YES, data.data);
        } else {
            block(NO, @"-1");
        }
    } failure:^(NSError *error) {
        block (NO, @"-1");
    }];
}

//发表评论
+ (void)addCommentForUser:(id)obj block:(void(^)(BOOL result))block {
    DynamicCommentListData *data = (DynamicCommentListData *)obj;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                data.type, @"type",
                                data.replyUid, @"replyUid",
                                data.replyId, @"replyId",
                                data.postId, @"postId",
                                data.parentCommentId, @"parentCommentId",
                                data.commentUid, @"commentUid",
                                data.replyContext, @"replyContext",
                                data.commentContext, @"commentContext",
                                data.isRole, @"isRole",
                                data.roleId, @"roleId", nil];
    
    [[DMHttpClient sharedInstance] initWithUrl:DM_Add_Comment_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//添加关注
+ (void)addFollowForUser:(NSMutableArray *)roleIDs block:(void(^)(BOOL result))block {
    NSString *userID = [AccountInfo getUserID];
    NSNumber *userIDNumber = [NSNumber numberWithInt:userID.intValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:roleIDs, @"roleId", userIDNumber, @"uid", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Add_Follow_Url parameters:dic method:DMHttpRequestPost dataModelClass:[PraiseDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            NSString *userFollowStatus = [AccountInfo getHasFollowStatus];
            if (userFollowStatus.integerValue != 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DMNotification_Follw_Success_Key object:nil userInfo:nil];
            }
            [AccountInfo saveUserHasFollow:@"1"];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}

//取消关注
+ (void)delFollowForUser:(NSString *)roleId block:(void(^)(BOOL result))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:roleId, @"roleId", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Del_Follow_Url parameters:dic method:DMHttpRequestPost dataModelClass:[PraiseDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNotification_Follw_Success_Key object:nil userInfo:nil];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//吐槽我的
+ (void)replyMeList:(NSString *)lastId block:(void(^)(BOOL result, NSArray *array))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastId, @"lastId", @"20", @"rowPage", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_ReplyMe_Url parameters:dic method:DMHttpRequestPost dataModelClass:[MsgData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            MsgData *model = (MsgData *)responseObject;
            block(YES, model.data);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}
//我吐槽的
+ (void)mySendList:(NSString *)lastId block:(void(^)(BOOL result, NSArray *array))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastId, @"lastId", @"20", @"rowPage", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_MySend_Url parameters:dic method:DMHttpRequestPost dataModelClass:[MsgData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            MsgData *model = (MsgData *)responseObject;
            block(YES, model.data);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}
//是否有未读消息
+ (void)getHasNoReadForUser:(void(^)(BOOL result))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_HasNoRead_Msg_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//收藏列表
+ (void)getCollectionListForUser:(NSString *)lastId block:(void(^)(BOOL result, NSArray *array))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastId, @"lastId", @"10", @"rowPage", userID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_CollectionList_Url parameters:dic method:DMHttpRequestPost dataModelClass:[CollectionData class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            if (![responseObject isKindOfClass:[NSString class]]) {
                CollectionData *model = (CollectionData *)responseObject;
                block(YES, model.data);
            } else {
                [ATools showSVProgressHudCustom:@"" title:(NSString *)responseObject];
                block(YES, nil);
            }
        } else {
            [ATools showSVProgressHudCustom:@"" title:@"暂无收藏"];
            block(YES, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//获取用户信息
+ (void)getUserInfoForUser:(void(^)(BOOL result))block {
    NSString *userID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID, @"uid", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Get_User_Info_Url parameters:dic method:DMHttpRequestPost dataModelClass:[UserDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
             UserDataModel *model = (UserDataModel *)responseObject;
            [AccountInfo saveAccountInfo:model];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}

//上传头像
+ (void)uploadHeadImageForUser:(UIImage *)image block:(void(^)(BOOL result, NSString *imageUrl))block {
    NSString *userID = [AccountInfo getUserID];
    //NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID, @"uId", imageData, @"file", nil];
    [[DMHttpClient sharedInstance] initWithUrl:Upload_Head_Image_Url parameters:dic method:DMHttpRequestFile dataModelClass:[PraiseDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            PraiseDataModel *model = (PraiseDataModel *)responseObject;
            block(YES, model.data);
        } else {
            block(NO, nil);
        }
    } failure:^(NSError *error) {
        block (NO, nil);
    }];
}

//微博登录
+ (void)loginWeibo:(NSDictionary *)dic block:(void(^)(BOOL result))block {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"access_token"], @"access_token", [dic objectForKey:@"uid"], @"uid", nil];
    [[DMHttpClient sharedInstance] initWithUrl:Login_Weibo_Url parameters:dic1 method:DMHttpRequestPost dataModelClass:[UserDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            UserDataModel *model = (UserDataModel *)responseObject;
            [AccountInfo saveAccountInfo:model];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//QQ登录
+ (void)loginQQ:(NSDictionary *)dic block:(void (^)(BOOL result)) block {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"open_id"], @"open_id", [dic objectForKey:@"access_token"], @"access_token", nil];
    [[DMHttpClient sharedInstance] initWithUrl:Login_QQ_Url parameters:dic1 method:DMHttpRequestPost dataModelClass:[UserDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            UserDataModel *model = (UserDataModel *)responseObject;
            [AccountInfo saveAccountInfo:model];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//微信登录
+ (void)loginWeiXin:(NSDictionary *)dic block:(void (^)(BOOL result))block{
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"access_token"], @"accesstoken", [dic objectForKey:@"open_id"], @"openid", nil];
    [[DMHttpClient sharedInstance] initWithUrl:Login_Wecat_Url parameters:dic1 method:DMHttpRequestPost dataModelClass:[UserDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            UserDataModel *model = (UserDataModel *)responseObject;
            [AccountInfo saveAccountInfo:model];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//绑定手机号验证码
+ (void)bindPhoneCode:(NSString *)phone block:(void(^)(BOOL result))block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone, @"phone",nil];
    [[DMHttpClient sharedInstance] initWithUrl:Bind_Phone_Code_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}

//绑定手机号
+ (void)bindPhoneForUser:(NSString *)phone psd:(NSString *)password code:(NSString *)code block:(void(^)(BOOL result))block {
    NSString *psdStr = [ATools MD5:password];
    NSString *countID = [AccountInfo getUserID];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone, @"phone", psdStr, @"password", code, @"verCode", countID, @"uId", nil];
    [[DMHttpClient sharedInstance] initWithUrl:Bind_Phone_Url parameters:dic method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            //保存数据
            [AccountInfo saveUserPhone:phone];
            block(YES);
        } else {
            block(NO);
        }
    } failure:^(NSError *error) {
        block (NO);
    }];
}
//下载文件
+ (void)downloadFileFromServer:(NSString *)fileUrl fileName:(NSString *)fileName block:(void(^)(BOOL result, NSString *filePathUrl))block progress:(void(^)(double fractionCompleted)) progressDownload {
    if (!STR_IS_NIL(fileUrl)) {
        NSURL *fileUrls = [NSURL URLWithString:fileUrl];
        [[DMHttpClient sharedInstance] downLoadFileRequest:fileUrls fileName:fileName success:^(id responseObject){
            NSURL *responseUrl = (NSURL *)responseObject;
            block(YES, responseUrl.path);
        } failure:^(NSError *error) {
            block(NO, nil);
        } progress:^(double fractionCompleted) {
            progressDownload(fractionCompleted);
        }];
    }
    
}

@end































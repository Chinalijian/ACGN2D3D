//
//  DMServerApiConfig.h
//  acgn
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#ifndef DMServerApiConfig_h
#define DMServerApiConfig_h

#define App_Version [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]

#define SERVER_ENVIRONMENT   0

/**************************************************************************************************************/

#if SERVER_ENVIRONMENT == 0 //正式
    #define DM_Local_Url @"http://www.jiayiworld.com/"//服务器访问地址
#elif

#endif

#define DM_Url      DM_Local_Url

//登录
#define DM_User_Loing_Url               [DM_Url stringByAppendingFormat:@"user/login"]
//注册
#define DM_User_Register_Url            [DM_Url stringByAppendingFormat:@"user/register"]
//注册获取验证码
#define DM_Register_Code_Url            [DM_Url stringByAppendingFormat:@"user/getVerCode"]
//找回密码验证码
#define DM_Find_Psd_Code_Url            [DM_Url stringByAppendingFormat:@"user/findByVerCode"]
//找回密码验证码校验
#define DM_Confirm_Code_Url             [DM_Url stringByAppendingFormat:@"user/confirmCode"]
//确认找回密码
#define DM_FindPassWord_Url             [DM_Url stringByAppendingFormat:@"user/findPassWord"]
//修改密码
#define DM_Modify_Psd_Url               [DM_Url stringByAppendingFormat:@"user/updatePassword"]
//修改昵称
#define DM_Modify_NickName_Url          [DM_Url stringByAppendingFormat:@"user/updateUserName"]
//首页角色列表
#define DM_Role_List_Url                [DM_Url stringByAppendingFormat:@"role/roleList"]
//首页关注列表
#define DM_FollowHome_Url               [DM_Url stringByAppendingFormat:@"post/isFollowHome"]
//首页广场
#define DM_HomePost_Url                 [DM_Url stringByAppendingFormat:@"post/homePost"]
//获取最新的帖子
#define DM_Latest_Post_Url              [DM_Url stringByAppendingFormat:@"post/refreshPost"]
//动态详情
#define DM_GetPostDetails_Url           [DM_Url stringByAppendingFormat:@"post/getPostDetils"]
//动态详情评论列表
#define DM_GetPostComment_List_Url      [DM_Url stringByAppendingFormat:@"post/getPostComment"]

//个人详情里 人物发的帖子列表
#define DM_GetRoleDetails_List_Url      [DM_Url stringByAppendingFormat:@"role/roleDetails"]
//个人详情人物信息
#define DM_GetRoleInfoDetails_Url       [DM_Url stringByAppendingFormat:@"role/getRoleInfo"]
//吐槽中心/二级评论详情
#define DM_GetCommentDetails_Url        [DM_Url stringByAppendingFormat:@"post/newCommentDetails"]//[DM_Url stringByAppendingFormat:@"post/getCommentDetails"]
//收藏
#define DM_Add_Collection_Url           [DM_Url stringByAppendingFormat:@"user/post/addCollection"]
//取消收藏
#define DM_Del_Collection_Url           [DM_Url stringByAppendingFormat:@"user/post/delCollection"]
//点赞-帖子
#define DM_Add_Fabulous_Url             [DM_Url stringByAppendingFormat:@"post/addFabulous"]
//取消点赞-帖子
#define DM_Del_Fabulous_Url             [DM_Url stringByAppendingFormat:@"post/delFabulous"]
//点赞-评论
#define DM_Add_Praise_Url               [DM_Url stringByAppendingFormat:@"comment/addPraise"]
//取消点赞-评论
#define DM_Del_Praise_Url               [DM_Url stringByAppendingFormat:@"comment/delPraise"]
//发表评论
#define DM_Add_Comment_Url              [DM_Url stringByAppendingFormat:@"post/addComment"]
//添加关注
#define DM_Add_Follow_Url               [DM_Url stringByAppendingFormat:@"user/addFollow"]
//取消关注
#define DM_Del_Follow_Url               [DM_Url stringByAppendingFormat:@"user/delFollow"]
//吐槽我的
#define DM_ReplyMe_Url                  [DM_Url stringByAppendingFormat:@"user/news/replyMe"]
//我吐槽的
#define DM_MySend_Url                   [DM_Url stringByAppendingFormat:@"user/news/mySend"]
//是否有未读消息
#define DM_HasNoRead_Msg_Url            [DM_Url stringByAppendingFormat:@"user/news/hasNoRead"]
//收藏列表
#define DM_CollectionList_Url           [DM_Url stringByAppendingFormat:@"user/post/collectionList"]
//获取用户信息
#define DM_Get_User_Info_Url            [DM_Url stringByAppendingFormat:@"user/getUserInfo"]
//上传头像
#define Upload_Head_Image_Url           [DM_Url stringByAppendingFormat:@"user/uploadAvatar"]

//weixin
#define Login_Wecat_Url                 [DM_Url stringByAppendingFormat:@"user/wxLogin"]
//qq
#define Login_QQ_Url                    [DM_Url stringByAppendingFormat:@"user/qqLogin"]
//weibo
#define Login_Weibo_Url                 [DM_Url stringByAppendingFormat:@"user/wbLogin"]
//绑定手机号获取验证码
#define Bind_Phone_Code_Url             [DM_Url stringByAppendingFormat:@"user/getBindCode"]
//绑定手机号
#define Bind_Phone_Url                  [DM_Url stringByAppendingFormat:@"user/bindPhone"]

#endif /* DMServerApiConfig_h */





//
//  AEnums.h
//  acgn
//
//  Created by Ares on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#ifndef AEnums_h
#define AEnums_h

typedef NS_ENUM(NSInteger, AAccountType) {
    AAccountType_Default     = 0,
    AAccountType_Login       = 1, // 登录
    AAccountType_Register    = 2, // 注册
    AAccountType_ResetPsd    = 3, // 找回密码
    AAccountType_SetPsd      = 4, // 重置密码
    AAccountType_NickName    = 5, // 修改昵称
    AAccountType_About       = 6, // 关于我们
    AAccountType_Msg         = 7, // 我的消息
    AAccountType_Fav         = 8, // 我的收藏
    AAccountType_ChangePsd   = 9, // 修改密码
    AAccountType_Edit        = 10,// 编辑资料
    AAccountType_BindPhone   = 11,// 绑定手机号
};

typedef NS_ENUM(NSInteger, Info_Type) {
    Info_Type_Text          = 0, // 文字
    //Info_Type_Picture       = 1, // 图片
    Info_Type_GIf_Pic       = 1, // 图片orGIF
    Info_Type_Video         = 3, // 视频
    Info_Type_Url_Video     = 4, // 第三方视频
};

typedef NS_ENUM(NSInteger, ContentCom_Type) {
    ContentCom_Type_LineNumber   = 0, // 行数限制
    ContentCom_Type_All          = 1, // 全部，没有行数限制
};

typedef NS_ENUM(NSInteger, Model_Show_Type) {
    Model_Show_Type_Default = 1, // 默认
    Model_Show_Type_2D      = 2, // 2d形象
    Model_Show_Type_3D      = 3, // 3d形象
};

#endif /* AEnums_h */






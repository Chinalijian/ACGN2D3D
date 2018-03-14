//
//  RoleDetailsDataModel.h
//  acgn
//
//  Created by lijian on 2018/2/9.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ABaseDataModel.h"
//人物详情里发的帖子列表
@interface RoleDetailsPostData: ABaseDataModel
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSArray  *postUrls;
@property (nonatomic, copy) NSString *postContext;
@property (nonatomic, copy) NSString *postTime;
@property (nonatomic, copy) NSString *postSource;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *postType;
@property (nonatomic, copy) NSString *seeNum;
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) NSString *fabulousNum;
@property (nonatomic, copy) NSString *replyNum;
@property (nonatomic, copy) NSString *hasFollow;
@property (nonatomic, copy) NSString *postUrl;

@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *hasCollection;
@property (nonatomic, copy) NSString *hasFabulousNum;
@property (nonatomic, assign) BOOL localPraise;//YES 已点，NO，未点
@end

@interface RoleDetailsPostListData: ABaseDataModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@end

//人物详情里的人物信息
@interface RoleDetailsDataModel : ABaseDataModel
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *hight;
@property (nonatomic, copy) NSString *hasFollow;
@property (nonatomic, copy) NSString *fansNum;
@property (nonatomic, copy) NSArray  *postList;//什么用，什么结构需要确认
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *showUrl;
@property (nonatomic, copy) NSString *showJson;
@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) NSString *fileName;
@end

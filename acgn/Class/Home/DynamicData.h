//
//  DynamicData.h
//  acgn
//
//  Created by lijian on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ABaseDataModel.h"

@interface DynamicCommentSecondData: NSObject
@property (nonatomic, copy) NSString *commentTime;
@property (nonatomic, copy) NSString *commentContext;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *replyUid;
@property (nonatomic, copy) NSString *replyContext;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *praiseNum;
@property (nonatomic, copy) NSString *commentUid;
@property (nonatomic, copy) NSString *parentCommentId;
@property (nonatomic, copy) NSString *otherName;
@end

@interface DynamicCommentListData: NSObject

@property (nonatomic, copy) NSString *commentTime;
@property (nonatomic, copy) NSString *commentContext;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *replyUid;
@property (nonatomic, copy) NSString *replyContext;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *praiseNum;
@property (nonatomic, copy) NSString *commentUid;
@property (nonatomic, copy) NSString *parentCommentId;
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) NSString *otherName;
@property (nonatomic, strong) NSArray *secondView;

//动态详情评论列表特有的   或者吐槽中心
@property (nonatomic, copy) NSString *hasFabulousNum;
@property (nonatomic, copy) NSString *hasPraise;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *roleAvatar;
@property (nonatomic, copy) NSString *isRole;
@property (nonatomic, copy) NSString *secondIsRole;
//吐槽中心
@property (nonatomic, copy) NSString *fabulousNum;

//发评论
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, copy) NSString *type;///本地使用

//是否点赞--本地使用
@property (nonatomic, assign) BOOL localPraise;//YES 已点，NO，未点


@end

@interface DynamicListData: NSObject
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, strong) NSArray *postUrls;
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
@property (nonatomic, copy) NSString *videoTime;
@property (nonatomic, strong) NSArray *commentList;

//动态详情里面特有的
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *hasCollection;
@property (nonatomic, copy) NSString *hasFabulousNum;

//收藏列表
@property (nonatomic, copy) NSString *collectionId;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSString *collectionTime;

//是否点赞--本地使用
@property (nonatomic, assign) BOOL localPraise;//YES 已点，NO，未点
@property (nonatomic, assign) BOOL favPage; //YES 是，NO，否

@end

@interface DynamicData : ABaseDataModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@end


@interface DynamicDetailsCommentData : ABaseDataModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@end






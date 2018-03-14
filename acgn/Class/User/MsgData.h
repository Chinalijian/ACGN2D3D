//
//  MsgData.h
//  acgn
//
//  Created by lijian on 2018/2/9.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ABaseDataModel.h"


//@interface MsgListData : ABaseDataModel
//@property (nonatomic, copy) NSString *commentTime;
//@property (nonatomic, copy) NSString *commentContext;
//@property (nonatomic, copy) NSString *userName;
//@property (nonatomic, copy) NSString *commentId;
//@property (nonatomic, copy) NSString *avatar;
//@property (nonatomic, copy) NSString *postId;
//@property (nonatomic, copy) NSString *replyUid;
//@property (nonatomic, copy) NSString *replyContext;
//@property (nonatomic, copy) NSString *uid;
//@property (nonatomic, copy) NSString *otherName;
//@property (nonatomic, copy) NSString *praiseNum;
//@property (nonatomic, copy) NSString *parentCommentId;
//@end

@interface MsgData : ABaseDataModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@end

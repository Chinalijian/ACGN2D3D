//
//  CollectionData.h
//  acgn
//
//  Created by lijian on 2018/2/9.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ABaseDataModel.h"

//@interface CollectionListData : ABaseDataModel
//
//@property (nonatomic, copy) NSString *collectionId;
//@property (nonatomic, copy) NSString *postId;
//@property (nonatomic, copy) NSString *uid;
//@property (nonatomic, copy) NSString *collectionTime;
//@property (nonatomic, copy) NSString *roleId;
//@property (nonatomic, strong) NSArray *postUrls;
//@property (nonatomic, copy) NSString *postContext;
//@property (nonatomic, copy) NSString *postTime;
//@property (nonatomic, copy) NSString *postSource;
//@property (nonatomic, copy) NSString *userName;
//@property (nonatomic, copy) NSString *imageUrl;
//@property (nonatomic, copy) NSString *postType;
//@property (nonatomic, copy) NSString *seeNum;
//@property (nonatomic, copy) NSString *commentNum;
//@property (nonatomic, copy) NSString *fabulousNum;
//@property (nonatomic, copy) NSString *replyNum;
//@property (nonatomic, copy) NSString *hasFollow;
//@property (nonatomic, copy) NSString *postUrl;
//@property (nonatomic, copy) NSString *thumbnailUrl;
//@property (nonatomic, copy) NSString *hasFabulousNum;
//@end

@interface CollectionData : ABaseDataModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@end

//
//  UserDataModel.h
//  acgn
//
//  Created by lijian on 2018/2/3.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ABaseDataModel.h"

@interface UserDataModel : ABaseDataModel
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *hasFollow;
@property (nonatomic, copy) NSString *phone;
@end

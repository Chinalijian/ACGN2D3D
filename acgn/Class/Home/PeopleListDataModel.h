//
//  PeopleListDataModel.h
//  acgn
//
//  Created by lijian on 2018/2/6.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleDataModel : NSObject
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * roleId;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * introduce;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * identity;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, copy) NSString * hight;
@property (nonatomic, copy) NSString * fansNum;
@property (nonatomic, copy) NSString * postList;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * hasFollow;

//本地字段
@property (nonatomic, assign) BOOL isSelected;

@end

@interface PeopleListDataModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@end

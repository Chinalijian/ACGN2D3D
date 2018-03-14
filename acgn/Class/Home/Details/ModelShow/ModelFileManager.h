//
//  ModelFileManager.h
//  acgn
//
//  Created by Ares on 2018/3/7.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelFileManager : NSObject
@property (nonatomic, strong) NSString *modefFileRoleID;
@property (nonatomic, strong) NSString *modelFilePathName;
@property (nonatomic, strong) NSString *modefFileAllPath;
@property (nonatomic, strong) NSString *modelFileShowJsonName;
+ (instancetype)shareInstance;
@end

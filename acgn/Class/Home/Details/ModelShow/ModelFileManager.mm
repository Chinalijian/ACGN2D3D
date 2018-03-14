//
//  ModelFileManager.m
//  acgn
//
//  Created by Ares on 2018/3/7.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ModelFileManager.h"

@interface ModelFileManager ()

@end

@implementation ModelFileManager

static ModelFileManager* _instance = nil;
+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [ModelFileManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [ModelFileManager shareInstance];
}
@end

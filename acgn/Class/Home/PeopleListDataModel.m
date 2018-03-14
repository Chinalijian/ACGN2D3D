//
//  PeopleListDataModel.m
//  acgn
//
//  Created by lijian on 2018/2/6.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "PeopleListDataModel.h"

@implementation PeopleDataModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _isSelected = YES;
    }
    return self;
}
@end

@implementation PeopleListDataModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"PeopleDataModel"
             };
}
@end

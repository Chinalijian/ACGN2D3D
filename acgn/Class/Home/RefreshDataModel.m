//
//  RefreshDataModel.m
//  acgn
//
//  Created by Ares on 2018/2/26.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "RefreshDataModel.h"

@implementation RefreshDataSubModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"latestPost": @"newPost"};
}
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"oldPost" : @"DynamicListData",
             @"latestPost" : @"DynamicListData",
             };
}
@end

@implementation RefreshDataModel

@end


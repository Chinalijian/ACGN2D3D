//
//  DynamicData.m
//  acgn
//
//  Created by lijian on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "DynamicData.h"
@implementation DynamicCommentSecondData

@end

@implementation DynamicCommentListData
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"secondView" : @"DynamicCommentSecondData"
             };
}
@end


@implementation DynamicListData
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"commentList" : @"DynamicCommentListData"
             };
}
@end

@implementation DynamicData
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"DynamicListData"
             };
}
@end


@implementation DynamicDetailsCommentData
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"DynamicCommentListData"
             };
}
@end




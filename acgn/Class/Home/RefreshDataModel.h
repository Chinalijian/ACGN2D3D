//
//  RefreshDataModel.h
//  acgn
//
//  Created by Ares on 2018/2/26.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefreshDataSubModel : NSObject
@property (nonatomic, copy) NSString *size;
@property (nonatomic, strong) NSArray *latestPost;
@property (nonatomic, strong) NSArray *oldPost;
@end

@interface RefreshDataModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) RefreshDataSubModel *data;
@end

//
//  ACLive2DManager.h
//  acgn
//
//  Created by Ares on 2018/3/14.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "LAppLive2DManager.h"
@interface ACLive2DManager : NSObject
//@property (nonatomic, retain) LAppLive2DManager* live2DMgr;

+ (instancetype)shareInstance;
- (void)loadLive2d:(UIView *)msView;
- (LAppLive2DManager *)getLive2dInit;
- (void)stopLive2d;
@end

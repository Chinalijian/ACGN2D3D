//
//  UnityController.h
//  UnityDemo
//
//  Created by Ares on 2018/3/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "UnityAppController.h"

@interface UnityController : UnityAppController
@property (nonatomic, readonly, weak) UIView *playView;  /* 展示Unity的view */

+ (instancetype)instance;
- (void)initUnity;
- (void)pauseUnity;
- (void)startUnity;
- (BOOL)isPaused;

@end

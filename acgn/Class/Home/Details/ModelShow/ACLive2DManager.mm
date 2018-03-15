//
//  ACLive2DManager.m
//  acgn
//
//  Created by Ares on 2018/3/14.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ACLive2DManager.h"
#import "IPhoneUtil.h"
#import "LAppModel.h"
#import "LAppDefine.h"


static ACLive2DManager* _instance = nil;

@implementation ACLive2DManager {
    LAppLive2DManager* live2DMgr;
    LAppView *viewA;
}

- (LAppLive2DManager *)getLive2dInit {
    return live2DMgr;
}

- (void)loadLive2d:(UIView *)msView {
    if (live2DMgr == nil) {
        live2DMgr = new LAppLive2DManager();
        CGRect screen = [IPhoneUtil getScreenRect];
        if (IS_IPHONE_X) {
            screen.size.height = screen.size.height+60;
        }
        viewA = live2DMgr->createView(screen);
        live2DMgr->changeModel();
        UIView *liView = (UIView *)viewA;
        // 画面に表示
        [msView addSubview:liView];
        
        [msView sendSubviewToBack:liView];
        
        if (LAppDefine::DEBUG_LOG) NSLog(@"viewWillAppear @ViewController");
        live2DMgr->onResume();
    } else {
        UIView *liView = (UIView *)viewA;
        // 画面に表示
        [msView addSubview:liView];
        [msView sendSubviewToBack:liView];
        live2DMgr->update();
    }
}

- (void)stopLive2d {
    if (live2DMgr == nil) {
        return;
    }
    if (LAppDefine::DEBUG_LOG) NSLog(@"viewWillDisappear @ViewController");
    live2DMgr->onPause();
}

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [ACLive2DManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [ACLive2DManager shareInstance];
}
@end

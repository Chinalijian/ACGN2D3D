//
//  UnityController.m
//  UnityDemo
//
//  Created by Ares on 2018/3/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "UnityController.h"

#import "UnityAppController+ViewHandling.h"
#import "UnityAppController+Rendering.h"

#import "DisplayManager.h"
#import "UnityView.h"

#include "RegisterMonoModules.h"
#include "RegisterFeatures.h"
#include <mach/mach_time.h>
#include <csignal>

@interface UnityController()

@property (nonatomic, assign) BOOL isInitUnity;

@end

@implementation UnityController

+ (instancetype)instance {
    return (UnityController *)[[UIApplication sharedApplication] valueForKeyPath:@"delegate.unityController"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isInitUnity = NO;
//        // 注册Unity的事件
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
//
    }
    return self;
}

- (UIView *)playView {
    return self.unityView;
}

static const int constsection = 0;

void UnityInitTrampoline();
//void UnityInitStartupTime();

void initMain() {
    signed long long startTime = mach_absolute_time();
    @autoreleasepool
    {
        UnitySetStartupTime(startTime);
//        UnityInitStartupTime();
        UnityInitTrampoline();
        UnityInitRuntime(0, NULL);
        
        
        RegisterMonoModules();
        NSLog(@"-> registered mono modules %p\n", &constsection);
        RegisterFeatures();
        
        // iOS terminates open sockets when an application enters background mode.
        // The next write to any of such socket causes SIGPIPE signal being raised,
        // even if the request has been done from scripting side. This disables the
        // signal and allows Mono to throw a proper C# exception.
        std::signal(SIGPIPE, SIG_IGN);
        
    }
}

- (void)initUnity {
    
    if (!self.isInitUnity) {
        
        initMain();
        
        
        if ([UIDevice currentDevice].generatesDeviceOrientationNotifications == NO)
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        UnityInitApplicationNoGraphics([[[NSBundle mainBundle] bundlePath] UTF8String]);
        [self selectRenderingAPI];
        [UnityRenderingView InitializeForAPI: self.renderingAPI];
        _window = nil;
        _unityView      = [self createUnityView];
        
        
        [DisplayManager Initialize];
        _mainDisplay    = [DisplayManager Instance].mainDisplay;
        [_mainDisplay createWithWindow: _window andView: _unityView];
        
        [super applicationDidBecomeActive:[UIApplication sharedApplication]];
        
        self.isInitUnity = YES;
    } else {
        if ([[UnityController instance] isPaused]) {
            [[UnityController instance] startUnity];
        }
    }
    
}

- (void)pauseUnity {
    
    //[self applicationWillResignActive:[UIApplication sharedApplication]];
    UnityPause(1);
}

- (void)startUnity {
    
    //[self applicationDidBecomeActive:[UIApplication sharedApplication]];
    UnityPause(0);
}

- (BOOL)isPaused {
    if (UnityIsPaused() == 1) {
        return YES;
    }
    else {
        return NO;
    }
}
//
//- (void)appWillEnterForeground:(NSNotification *)notification {
//    [self applicationWillEnterForeground:[UIApplication sharedApplication]];
//}
//
//- (void)appDidBecomeActive:(NSNotification *)notification {
//    if (nil == self.unityView) {
//        return;
//    }
//    [self applicationDidBecomeActive:[UIApplication sharedApplication]];
//}
//
//- (void)appWillResignActive:(NSNotification *)notification {
//    [self applicationWillResignActive:[UIApplication sharedApplication]];
//}
//
//- (void)appWillTerminate:(NSNotification *)notification {
//    [self applicationWillTerminate:[UIApplication sharedApplication]];
//}
//
//- (void)appDidReceiveMemoryWarning:(NSNotification *)notification {
//    [self applicationDidReceiveMemoryWarning:[UIApplication sharedApplication]];
//}

@end

/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#pragma once

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>

//#import "util/UtSystem.h"
#import "UtSystem.h"

@class SimpleImage;
class LAppLive2DManager;

@interface LAppRenderer : NSObject
{
@private
	int renderInitFlg ;
    
	LAppLive2DManager * delegate ;
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint viewportWidth;
	GLint viewportHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
	
	// 背景
    SimpleImage* bg;
	
	// 加速度
	float accelX;
	float accelY;
}
- (id) init;
- (void) renderInit;
- (void) render;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

// Live2DManagerの参照を設定する
- (void) setDelegate:(LAppLive2DManager *) del ;

// 別スレッドでテクスチャをロードするような場合に使用する
- (void) setContextCurrent ;

- (void) setupBackground;
- (void) setAccel:(float)x :(float)y;
@end





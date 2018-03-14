/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface OffscreenImage : NSObject

+(void)createFrameBuffer:(float)w :(float)h :(GLuint)fbo;
+(void)releaseFrameBuffer;
+(void)setOffscreen;
+(void)setOnscreen;
+(void) drawDisplay: (float) opacity;
@end

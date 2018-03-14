/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@interface FileManager : NSObject

+ (NSData*) openBundle:(NSString*)fileName;
+ (NSData*) openBundleWithCString:(const char*)fileName;
+ (NSData*) openDocuments:(NSString*)fileName;
+ (NSData*) openDocumentsWithCString:(const char*)fileName;

+ (const char*) pathForResource:(const char*)fileName;
+ (NSURL*) getFileURLWithCString:(const char*)fileName;
+ (GLuint)loadGLTexture:(NSString*)fileName;
+ (GLuint) loadBGLTexture:(NSString*)fileName;
@end

/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */

#import "FileManager.h"
@implementation FileManager

const bool DEBUG_LOG=false;// デバッグログ表示切り替え


// アプリケーションフォルダから取得
+ (const char*) pathForResource:(const char*)fileName 
{
    //Ares modify
	//NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]];
    
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]];
    
    return [path cStringUsingEncoding:NSUTF8StringEncoding];
}


// 文字列をURL形式にする
+ (NSURL*) getFileURLWithCString:(const char*)fileName
{
	NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]];
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    	NSURL* url = [NSURL fileURLWithPath:path];
	return url;
}


// ドキュメントフォルダから開く
+ (NSData*)openDocuments:(NSString*)fileName {
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:fileName]; 
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}


// ドキュメントフォルダから開く
+ (NSData*) openDocumentsWithCString:(const char*)fileName
{
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path=[path stringByAppendingPathComponent:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]]; 
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}


// バンドルデータから開く
+ (NSData*)openBundle:(NSString*)fileName {
    NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:fileName];
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}


// バンドルデータから開く
+ (NSData*) openBundleWithCString:(const char*)fileName
{
    NSString* path=[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding]]; 
    
    if(DEBUG_LOG)NSLog(@"open :%@",path);
    NSData* data=[[NSData alloc] initWithContentsOfFile:path] ; 
    
    if (data==nil) {
        if(DEBUG_LOG)NSLog(@"error! :%@",path);
        return nil;
    }
    return data;
}
// 画像ファイルからテクスチャを作成します
+ (GLuint) loadGLTexture:(NSString*) fileName
{
    NSLog(@"调用调用调用嗲用");
	GLuint texture;
	
    // Ares modify
	// 画像ファイルを展開しCGImageRefを生成します
	//UIImage *uiImage = [UIImage imageNamed:fileName];
    NSString* path =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:fileName];
    UIImage *uiImage = [[UIImage alloc] initWithContentsOfFile:path];
    
	if(!uiImage)// 画像ファイルの読み込みに失敗したらfalse(0)を返します
	{
		NSLog(@"Error: %@ not found",fileName);
        [ATools showSVProgressHudCustom:@"" title:@"加载失败1"];
		return 0;
	}
	

	CGImageRef image = uiImage.CGImage ;
	
	// 画像の大きさを取得します
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
	
	// ビットマップデータを用意します
	GLubyte* imageData = (GLubyte *) calloc(width * height * 4 , 1);
	CGContextRef imageContext = CGBitmapContextCreate(imageData,width,height,8,width * 4,CGImageGetColorSpace(image),kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(imageContext, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), image);
	CGContextRelease(imageContext);
    
	// OpenGL用のテクスチャを生成します
	glGenTextures(1, &texture);
	glBindTexture(GL_TEXTURE_2D, texture);
    
	glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    //[ATools showSVProgressHudCustom:@"" title:@"加载失败2"];
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    [lock unlock];
	free(imageData);

	GLenum error = glGetError() ;
	if( error )
	{
        NSLog(@"load texture error : %d",error);
	}
	
	// 作成したテクスチャを返します
	return texture;
}

// 画像ファイルからテクスチャを作成します
+ (GLuint) loadBGLTexture:(NSString*)fileName
{
    GLuint texture;
    
    // 画像ファイルを展開しCGImageRefを生成します
    UIImage *uiImage = [UIImage imageNamed:fileName];
    
    if(!uiImage)// 画像ファイルの読み込みに失敗したらfalse(0)を返します
    {
        NSLog(@"Error: %@ not found",fileName);
        return 0;
    }
    
    CGImageRef image = uiImage.CGImage ;
    
    // 画像の大きさを取得します
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    // ビットマップデータを用意します
    GLubyte* imageData = (GLubyte *) calloc(width * height * 4 , 1);
    CGContextRef imageContext = CGBitmapContextCreate(imageData,width,height,8,width * 4,CGImageGetColorSpace(image),kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), image);
    CGContextRelease(imageContext);
    
    // OpenGL用のテクスチャを生成します
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    free(imageData);
    
    GLenum error = glGetError() ;
    if( error )
    {
        NSLog(@"load texture error : %d",error);
    }
    
    // 作成したテクスチャを返します
    return texture;
}


@end

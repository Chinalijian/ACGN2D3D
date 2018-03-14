/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#import <mach/mach_time.h>

#import "LAppRenderer.h"
#import "LAppDefine.h"
#import "LAppModel.h"
#import "LAppLive2DManager.h"

#import "L2DViewMatrix.h"
#import "L2DModelMatrix.h"

//utils
#import "SimpleImage.h"
#import "OffscreenImage.h"

@implementation LAppRenderer

using namespace live2d::framework;


//==================================================
// Init
//==================================================
// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            return nil;
        }
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
        //glClearColor(0, 0, 0, 0);
        [self setupBackground];
		accelX=0;
		accelY=0;
	}
    
	return self;
}


- (void) dealloc
{
	[OffscreenImage releaseFrameBuffer];
	[bg deleteTexture];
	
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}
	
	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	
	context = nil;
	delegate=nil;
}


-(void)renderInit
{
	// OpenGL初期化
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	
	if(LAppDefine::DEBUG_LOG)NSLog(@"viewport w:%d h:%d",viewportWidth, viewportHeight);
	// Viewportの設定。デバイスと論理スクリーンの表示範囲をあわせる。
	glViewport(0, 0, viewportWidth, viewportHeight);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	
	// ここで指定した範囲が、表示される
	// glOrthof( Xの左端, Xの右端, Yの下端, Yの上端, Zの手前, Zの奥);
	L2DViewMatrix* viewMatrix=delegate->getViewMatrix();
	glOrthof( viewMatrix->getScreenLeft()
			 , viewMatrix->getScreenRight(), viewMatrix->getScreenBottom(), viewMatrix->getScreenTop(), 0.5f, -0.5f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);// 背景色
	
	[OffscreenImage createFrameBuffer:viewportWidth: viewportHeight :defaultFramebuffer];
}


//==================================================
// Render
//==================================================
- (void) render
{
	
    if( viewportWidth <= 0 || viewportHeight <= 0 )return;
	
	[EAGLContext setCurrentContext:context];// OpenGLのコンテキストを設定
	
	if( renderInitFlg )
	{
		[self renderInit];
		renderInitFlg=false;
	}
	
	// 画面をクリア
	glClear(GL_COLOR_BUFFER_BIT);
  
    // OpenGLをLive2D用の設定にする
    glDisable(GL_DEPTH_TEST) ;// デプステストを行わない
    glDisable(GL_CULL_FACE) ;// カリングを行わない
    glEnable(GL_BLEND);// ブレンドを行う
    glBlendFunc(GL_ONE , GL_ONE_MINUS_SRC_ALPHA );// ブレンド方法の指定
    
    glEnable( GL_TEXTURE_2D ) ;
    glEnableClientState(GL_TEXTURE_COORD_ARRAY) ;
    glEnableClientState(GL_VERTEX_ARRAY) ;
    
    // テクスチャのクランプ指定
    glTexParameteri(GL_TEXTURE_2D , GL_TEXTURE_WRAP_S , GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D , GL_TEXTURE_WRAP_T , GL_CLAMP_TO_EDGE);
		
    glColor4f( 1 , 1, 1, 1  ) ;
    
    // 背景とモデルの描画
	glMatrixMode(GL_MODELVIEW) ;
    glLoadIdentity() ;
	
    glPushMatrix() ;
    {
        // 画面の拡大縮小、移動を設定
		L2DViewMatrix* viewMatrix=delegate->getViewMatrix();
        glMultMatrixf(viewMatrix->getArray()) ;
		
        //  背景の描画
        if(bg!=NULL){
            glPushMatrix() ;
            {
				float SCALE_X = 0.25f ;// デバイスの回転による揺れ幅
				float SCALE_Y = 0.1f ;
                glTranslatef( -SCALE_X  * accelX , SCALE_Y * accelY , 0 ) ;// 揺れ
                
                [bg draw];
            }
            glPopMatrix() ;
        }
		
		// キャラの描画
		for (int i=0; i<delegate->getModelNum(); i++) {
			LAppModel* model=delegate->getModel(i);
			if (model->isInitialized() && ! model->isUpdating() ) {
				model->update();
				model->draw();
			}
		}
	}
    glPopMatrix() ;
    
	// 描画先を指定して描画開始
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


//==================================================
//	resizeFromLayer
//==================================================
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &viewportWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &viewportHeight);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
	renderInitFlg = true ;// 再度初期化が走るようにする
    return YES;
}


//==================================================
// 	親の設定
//==================================================
- (void) setDelegate:( LAppLive2DManager * ) del
{
	delegate = del ;
}


// 別スレッドでテクスチャをロードするような場合に使用する
- (void) setContextCurrent
{
    [EAGLContext setCurrentContext:context];
}


/*
 * 背景の設定
 * @param gl
 */
- (void) setupBackground
{
    
    NSString* path=[NSString stringWithCString:BACK_IMAGE_NAME encoding:NSUTF8StringEncoding] ;
    
    
    if(LAppDefine::DEBUG_LOG)NSLog( @"background : %@",path);
    
    bg = [[SimpleImage alloc] initWithPath:path];
    
    // 描画範囲。画面の最大表示範囲に合わせる
    [bg setDrawRect:
		VIEW_LOGICAL_MAX_LEFT:VIEW_LOGICAL_MAX_RIGHT:VIEW_LOGICAL_MAX_BOTTOM:VIEW_LOGICAL_MAX_TOP];
    

}


-(void)setAccel:(float)x :(float)y
{
	accelX=x;
	accelY=y;
}

@end

/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */

#import "SimpleImage.h"

#import "FileManager.h"

@implementation SimpleImage


- (id)initWithPath:(NSString*) path {
    self = [super init];
    if(self) {
        texture=[FileManager loadBGLTexture:path];
        
        // 初期設定
        uvLeft=0;
        uvRight=1;
        uvBottom=0;
        uvTop=1;
        
        imageLeft=-1;
        imageRight=1;
        imageBottom=-1;
        imageTop=1;
    }
	
    return self;
}


- (void) draw
{
    float uv[] = { uvLeft ,uvBottom,uvRight  ,uvBottom, uvRight, uvTop, uvLeft,uvTop} ;
    float ver[] = { imageLeft , imageTop   , imageRight     , imageTop , imageRight      , imageBottom     , imageLeft , imageBottom } ;
    short index[] = {0,1,2 , 0,2,3} ;
    
    glTexCoordPointer( 2, GL_FLOAT , 0 , uv ) ;
    glVertexPointer( 2 , GL_FLOAT , 0 , ver ) ;
    glBindTexture(GL_TEXTURE_2D , texture ) ;
    
    glDrawElements( GL_TRIANGLES, 6 , GL_UNSIGNED_SHORT , index ) ;
}


- (void)deleteTexture
{
	glDeleteTextures(1, &texture);
}


/*
 * テクスチャの描画先の座標を設定(デフォルトは 0,0,1,1 に描かれる)
 *
 * @param left
 * @param right
 * @param bottom
 * @param top
 */
- (void) setDrawRect:(float) left :(float) right :(float) bottom :(float) top
{
    imageLeft=left;
    imageRight=right;
    imageBottom=bottom;
    imageTop=top;
}


/*
 * テクスチャの使用範囲を設定（テクスチャは0..1座標）
 * @param left
 * @param right
 * @param bottom
 * @param top
 */
- (void) setUVRect:(float) left :(float) right :(float) bottom :(float) top
{
    uvLeft=left;
    uvRight=right;
    uvBottom=bottom;
    uvTop=top;
}

@end

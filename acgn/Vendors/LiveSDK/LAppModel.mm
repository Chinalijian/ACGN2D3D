/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#include "LAppModel.h"

//Objective C
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//Live2D Application
#include "LAppDefine.h"

#include "L2DStandardID.h"

//utils
#import "FileManager.h"
#import "OffscreenImage.h"
#include "ModelSettingJson.h"

using namespace std;
using namespace live2d;
using namespace live2d::framework;

LAppModel::LAppModel()
	:L2DBaseModel(),modelSetting(NULL),voice(NULL)
{
	if (LAppDefine::DEBUG_LOG) mainMotionMgr->setMotionDebugMode(true);
}


LAppModel::~LAppModel(void)
{
	if(LAppDefine::DEBUG_LOG)NSLog(@"delete model");
	
	delete modelSetting;
	
	if( voice )
	{
		[voice stop ] ;
		voice = NULL ;
	}
}


/*
 * Live2DモデルをOpenGLを使用して初期化する。
 * OpenGLは別々のスレッドからアクセスできないので注意。
 * メインスレッドからOpenGLを初期化しているなら、このメソッドもメインスレッドから呼ぶこと。
 */
void LAppModel::load(const char path[])
{
    string modelSettingPath = path;
	NSString* dir = [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
	
    modelHomeDir = [[dir stringByDeletingLastPathComponent] UTF8String];
	modelHomeDir += "/";
    
    if(LAppDefine::DEBUG_LOG)NSLog( @"create model : %s",path);	
    updating=true;
    initialized=false;
    
    //NSData* data=[FileManager openBundleWithCString: modelSettingPath.c_str() ];
    
    NSData *data = [FileManager openDocumentsWithCString:modelSettingPath.c_str()];
    
    int myLenght = [[NSString stringWithFormat:@"%lu",(unsigned long)[data length]] intValue];
    modelSetting=new ModelSettingJson((const char*)[data bytes], myLenght);
    
    if(strcmp( modelSetting->getModelFile() , "" ) != 0 )
    {
		string path=modelSetting->getModelFile();
		path = modelHomeDir + path;
        loadModelData(path.c_str());
		
		int len = modelSetting->getTextureNum();
		textures.resize(len);

        for (int i=0; i<len; i++)
        {
            string texturePath = modelSetting->getTextureFile(i);
            
            texturePath = modelHomeDir+texturePath;
            
            loadTexture(i,texturePath.c_str());
        }
    }
    
    
    //Expression
	if (modelSetting->getExpressionNum() > 0)
	{
		int len=modelSetting->getExpressionNum();
		for (int i=0; i<len; i++)
		{
			string name=modelSetting->getExpressionName(i);
			string file=modelSetting->getExpressionFile(i);
			file=modelHomeDir+file;
			loadExpression(name.c_str(),file.c_str());
		}
	}
	
	//Physics
	if( strcmp( modelSetting->getPhysicsFile(), "" ) != 0 )
    {
		string path = modelSetting->getPhysicsFile();
		path = modelHomeDir+path;
        loadPhysics(path.c_str());
    }
	
	//Pose
	if( strcmp( modelSetting->getPoseFile() , "" ) != 0 )
    {
		string path=modelSetting->getPoseFile();
		path=modelHomeDir+path;
        loadPose(path.c_str());
    }

	
	// 目パチ
	if (eyeBlink==NULL)
	{
		eyeBlink=new L2DEyeBlink();
	}
	
	// レイアウト
	map<string, float> layout;
	modelSetting->getLayout(layout);
	modelMatrix->setupLayout(layout);
	
	for ( int i = 0; i < modelSetting->getInitParamNum(); i++)
	{
		live2DModel->setParamFloat(modelSetting->getInitParamID(i), modelSetting->getInitParamValue(i));
	}

	for ( int i = 0; i < modelSetting->getInitPartsVisibleNum(); i++)
	{
		live2DModel->setPartsOpacity(modelSetting->getInitPartsVisibleID(i), modelSetting->getInitPartsVisibleValue(i));
	}
	
	live2DModel->saveParam();

	preloadMotionGroup(MOTION_GROUP_IDLE);
	
	mainMotionMgr->stopAllMotions();
	
    updating=false;// 更新状態の完了
    initialized=true;// 初期化完了
}


void LAppModel::preloadMotionGroup(const char name[])
{
    int len = modelSetting->getMotionNum( name );
    for (int i = 0; i < len; i++)
	{
		string motionFile = modelSetting->getMotionFile(name,i);
		string path = modelHomeDir + motionFile;
        
        if(LAppDefine::DEBUG_LOG)NSLog(@"load motion name:%s",motionFile.c_str());
        
        AMotion* motion = Live2DMotion::loadMotion([FileManager pathForResource:path.c_str()]);
        motion->setFadeIn(  modelSetting->getMotionFadeIn(name,i)  );
        motion->setFadeOut( modelSetting->getMotionFadeOut(name,i) );
        
        motions[motionFile]= motion ;
    }
}


void LAppModel::update()
{
	dragMgr->update();
	dragX=dragMgr->getX();
	dragY=dragMgr->getY();
	
	//-----------------------------------------------------------------
	live2DModel->loadParam();// 前回セーブされた状態をロード
	if(mainMotionMgr->isFinished())
	{
		// モーションの再生がない場合、待機モーションの中からランダムで再生する
		startRandomMotion(MOTION_GROUP_IDLE, PRIORITY_IDLE);
	}
	else
	{
		bool update = mainMotionMgr->updateParam(live2DModel);// モーションを更新
		
		if( ! update){
			// メインモーションの更新がないとき
			eyeBlink->setParam(live2DModel);// 目パチ
		}
	}
	live2DModel->saveParam();// 状態を保存
	//-----------------------------------------------------------------
	
	
	if(expressionMgr!=NULL)expressionMgr->updateParam(live2DModel);//  表情でパラメータ更新（相対変化）
	
	
	// ドラッグによる変化
	// ドラッグによる顔の向きの調整
	live2DModel->addToParamFloat( PARAM_ANGLE_X, dragX *  30 , 1 );// -30から30の値を加える
	live2DModel->addToParamFloat( PARAM_ANGLE_Y, dragY *  30 , 1 );
	live2DModel->addToParamFloat( PARAM_ANGLE_Z, (dragX*dragY) * -30 , 1 );
	
	// ドラッグによる体の向きの調整
	live2DModel->addToParamFloat( PARAM_BODY_ANGLE_X    , dragX * 10 , 1 );// -10から10の値を加える
	
	// ドラッグによる目の向きの調整
	live2DModel->addToParamFloat( PARAM_EYE_BALL_X, dragX  , 1 );// -1から1の値を加える
	live2DModel->addToParamFloat( PARAM_EYE_BALL_Y, dragY  , 1 );
	
	// 呼吸など
	long timeMSec = UtSystem::getUserTimeMSec() - startTimeMSec  ;
	double t = (timeMSec / 1000.0) * 2 * 3.14159  ;// 2πt
	
	live2DModel->addToParamFloat( PARAM_ANGLE_X,	(float) (15 * sin( t/ 6.5345 )) , 0.5f);// -15 ~ +15 まで周期的に加算。周期は他とずらす。
	live2DModel->addToParamFloat( PARAM_ANGLE_Y,	(float) ( 8 * sin( t/ 3.5345 )) , 0.5f);
	live2DModel->addToParamFloat( PARAM_ANGLE_Z,	(float) (10 * sin( t/ 5.5345 )) , 0.5f);
	live2DModel->addToParamFloat( PARAM_BODY_ANGLE_X,	(float) ( 4 * sin( t/15.5345 )) , 0.5f);
	live2DModel->setParamFloat  ( PARAM_BREATH,	(float) (0.5f + 0.5f * sin( t/3.2345 )),1);// 0~1 まで周期的に設定。モーションを上書き。
	
	// 加速度による変化
	live2DModel->addToParamFloat(PARAM_ANGLE_Z, 90 * accelX ,0.5f);
//	live2DModel->addToParamFloat(PARAM_ANGLE_Y,-90 * accelY ,0.5f);
//	live2DModel->addToParamFloat(PARAM_ANGLE_Z, 10 * accelX ,0.5f);
	
	if(physics!=NULL)physics->updateParam(live2DModel);// 物理演算でパラメータ更新

	// リップシンクの設定
	if(lipSync)
	{
		float value=0;// システムから音量を取得して0から1の値にする
		live2DModel->setParamFloat(PARAM_MOUTH_OPEN_Y, value ,0.8f);
	}
	
	// ポーズの設定
	if(pose!=NULL)pose->updateParam(live2DModel);

	live2DModel->update();
}


/*
 * モデルを描画する。
 * プラットフォームごとの固有設定も行う。
 * モデルが設定されてない場合は何もしない。
 * @param gl
 */
void LAppModel::draw()
{
    if (live2DModel == NULL)return;
	alpha+=accAlpha;
	if (alpha<0)
	{
		alpha=0;
		accAlpha=0;
	}
	else if (alpha>1)
	{
		alpha=1;
		accAlpha=0;
	}
	
	if(alpha<=0)return;
	
	if (alpha<1)
	{
		// 半透明
		// オフスクリーンにモデルを描画
		[OffscreenImage setOffscreen];
		glClear(GL_COLOR_BUFFER_BIT);
		glPushMatrix() ;
		{
			float* tr=modelMatrix->getArray();
			glMultMatrixf(tr) ;
			live2DModel->draw();
		}
		glPopMatrix() ;
		
		// 実際のウィンドウに半透明で描画
		[OffscreenImage setOnscreen];
		glPushMatrix() ;
		{
			glLoadIdentity();
			[OffscreenImage drawDisplay:alpha];
		}
		glPopMatrix() ;
	}
	else
	{
		// 通常描画。
		glPushMatrix() ;
		{
			float* tr=modelMatrix->getArray();
			glMultMatrixf(tr) ;
			live2DModel->draw();
			
		}
		glPopMatrix() ;
		
		if(LAppDefine::DEBUG_DRAW_HIT_AREA )
		{
			// デバッグ用当たり判定の描画
			drawHitRect();
		}
	}
}


int LAppModel::startMotion(const char name[],int no,int priority)
{
	if (priority==PRIORITY_FORCE)
	{
		mainMotionMgr->setReservePriority(priority);
	}
	else if (! mainMotionMgr->reserveMotion(priority))
	{
		if(LAppDefine::DEBUG_LOG)NSLog(@"motion not start");
		return -1;
	}
	
	string motionFile = modelSetting->getMotionFile(name, no);
	AMotion* motion = motions[motionFile];
	bool autoDelete = false;
	
	if ( motion == NULL )
	{
		// 読み込み
		string path=modelHomeDir+motionFile;
		
		if(LAppDefine::DEBUG_LOG)NSLog(@"load motion name:%s ",motionFile.c_str());
		
		motion = Live2DMotion::loadMotion([FileManager pathForResource:path.c_str()]);
		motion->setFadeIn(  modelSetting->getMotionFadeIn(name,no)  );
		motion->setFadeOut( modelSetting->getMotionFadeOut(name,no) );
		
		autoDelete = true;
	}
	
	if( strcmp( modelSetting->getMotionSound(name, no) , "" ) == 0)
	{
		if(LAppDefine::DEBUG_LOG)NSLog(@"start motion : %s ",motionFile.c_str());
		return mainMotionMgr->startMotionPrio(motion,autoDelete,priority);// 終了時にメモリから削除
	}
	else
	{
		string soundName=modelSetting->getMotionSound(name, no);
		string soundPath=modelHomeDir + soundName;
		
		if(LAppDefine::DEBUG_LOG)NSLog(@"start motion : %s  sound : %s",motionFile.c_str(),soundName.c_str());
		startVoice(soundPath.c_str());
		
		return mainMotionMgr->startMotionPrio(motion,autoDelete,priority);// 終了時にメモリから削除
	}
}


int LAppModel::startRandomMotion(const char name[],int priority)
{
    if(modelSetting->getMotionNum(name)==0){
        return -1;
    }
    int tapIndex = modelSetting->getMotionNum(name);
    int no = rand() % tapIndex;
    
    return startMotion(name,no,priority);
}


void LAppModel::setExpression(const char expressionID[])
{
	AMotion* motion = expressions[expressionID] ;
	if(LAppDefine::DEBUG_LOG)NSLog( @"expression[%s]" , expressionID ) ;
	if( motion != NULL )
	{
		expressionMgr->startMotion(motion, false) ;
	}
	else
	{
		if(LAppDefine::DEBUG_LOG)NSLog( @"expression[%s] is null " , expressionID ) ;
	}
}


void LAppModel::setRandomExpression()
{
	int no=rand()%expressions.size();
	map<string,AMotion* >::const_iterator map_ite;
	int i=0;
	for(map_ite=expressions.begin();map_ite!=expressions.end();map_ite++)
	{
		if (i==no)
		{
			string name=(*map_ite).first;
			setExpression(name.c_str());
			return;
		}
		i++;
	}
}


/*
 * 当たり判定との簡易テスト。
 * 指定IDの頂点リストからそれらを含む最大の矩形を計算し、点がそこに含まれるか判定
 *
 * @param id
 * @param testX
 * @param testY
 * @return
 */
bool LAppModel::hitTest(const char pid[],float testX,float testY)
{
	if(alpha<1)return false;// 透明時は当たり判定なし。
	int len=modelSetting->getHitAreasNum();
	for (int i = 0; i < len; i++)
	{
		if( strcmp( modelSetting->getHitAreaName(i) ,pid) == 0 )
		{
			const char* drawID=modelSetting->getHitAreaID(i);
			int drawIndex=live2DModel->getDrawDataIndex(drawID);
			if(drawIndex<0)return false;// 存在しない場合はfalse
			int count=0;
			float* points=live2DModel->getTransformedPoints(drawIndex,&count);
			
			float left=live2DModel->getCanvasWidth();
			float right=0;
			float top=live2DModel->getCanvasHeight();
			float bottom=0;
			
			for (int j = 0; j < count*2; j=j+2)
			{
				float x = points[j];
				float y = points[j+1];
				if(x<left)left=x;	//  最小のx
				if(x>right)right=x;	//  最大のx
				if(y<top)top=y;		//  最小のy
				if(y>bottom)bottom=y;//  最大のy
			}
			
			float tx=modelMatrix->invertTransformX(testX);
			float ty=modelMatrix->invertTransformY(testY);
			
			return ( left <= tx && tx <= right && top <= ty && ty <= bottom ) ;
		}
	}
	return false;// 存在しない場合はfalse
}


void LAppModel::startVoice( const char filename[] )
{
	if( voice )
	{
		[voice stop ] ;
		voice = NULL ;
	}
	
	// セリフ用のAVAudioPlayerを生成します
	NSURL *url = [FileManager getFileURLWithCString:filename];
	if( url )
	{
		voice = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		[voice setNumberOfLoops:0];
		[voice play];
		[voice setMeteringEnabled: YES] ;
	}
	else
	{
		if(LAppDefine::DEBUG_LOG)NSLog(@"sound file not exists. %s",filename);
	}
}


void LAppModel::feedIn()
{
	alpha=0;
	accAlpha=0.05;
}


/*
 * デバッグ用当たり判定の表示
 */
void LAppModel::drawHitRect()
{
	glDisable( GL_TEXTURE_2D ) ;
	glDisableClientState( GL_TEXTURE_COORD_ARRAY ) ;
	glEnableClientState( GL_VERTEX_ARRAY );
	glEnableClientState( GL_COLOR_ARRAY );
	glPushMatrix() ;
	{
		glMultMatrixf(modelMatrix->getArray()) ;
		int len = modelSetting->getHitAreasNum();
		for (int i=0;i<len;i++)
		{
			string drawID=modelSetting->getHitAreaID(i);
			int drawIndex=live2DModel->getDrawDataIndex(drawID.c_str());
			if(drawIndex<0)continue;
			int count=0;
			float* points=live2DModel->getTransformedPoints(drawIndex,&count);
			float left=live2DModel->getCanvasWidth();
			float right=0;
			float top=live2DModel->getCanvasHeight();
			float bottom=0;
			
			for (int j = 0; j < count*2; j=j+2)
			{
				float x = points[j];
				float y = points[j+1];
				if(x<left)left=x;	//  最小のx
				if(x>right)right=x;	//  最大のx
				if(y<top)top=y;		//  最小のy
				if(y>bottom)bottom=y;//  最大のy
			}
			float vertex[]={left,top,right,top,right,bottom,left,bottom,left,top};
			// 色は適当に作る
			float r=(i%2==0)?1:0;
			float g=(i/2%2==0)?1:0;
			float b=(i/4%2==0)?1:0;
			float a=0.5f;
			int size=2;
			float color[] = {r,g,b,a,r,g,b,a,r,g,b,a,r,g,b,a,r,g,b,a};
			
			glLineWidth( size );	// 描画サイズをsizeにする
			glVertexPointer( 2, GL_FLOAT, 0, vertex );	// 表示座標のセット
			glColorPointer( 4, GL_FLOAT, 0, color );	// カラーのセット
			glDrawArrays( GL_LINE_STRIP, 0, 5 );	// pointNumだけ描画する
		}
	}
	glPopMatrix() ;
	glEnable( GL_TEXTURE_2D ) ;
	glEnableClientState( GL_TEXTURE_COORD_ARRAY ) ;
	glEnableClientState( GL_VERTEX_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );
}

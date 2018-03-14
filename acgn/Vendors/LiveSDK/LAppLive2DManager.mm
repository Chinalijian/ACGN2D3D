/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#include "LAppLive2DManager.h"

#include "L2DViewMatrix.h"

//Live2DApplication
#include "LAppModel.h"
#include "LAppDefine.h"
#include "LAppModel.h"
#include "L2DMotionManager.h"

#include "PlatformManager.h"
#include "Live2DFramework.h"

//utils
#import "IPhoneUtil.h"

//Objective C
#import "AppDelegate.h"
#import "LAppView.h"
#import "ModelFileManager.h"

using namespace live2d;
using namespace live2d::framework;

LAppLive2DManager::LAppLive2DManager()
	:modelCount(-1),reloadFlg(false)
{
	// 以下の命令でメモリリークの検査を実施（DEBUGモードのみ）
	// Live2D::dispose()時に、Live2Dの管理するメモリでリークが発生していた場合にダンプする
	// 	リークしている場合は、MEMORY_DEBUG_MEMORY_INFO_ALLでより詳細な情報をダンプします
	// 検査用のデータはglobal new演算子を使います
	// live2d::UtDebug::addMemoryDebugFlags( live2d::UtDebug::MEMORY_DEBUG_MEMORY_INFO_COUNT ) ;//メモリリークの検出用
	
	Live2D::init();
	Live2DFramework::setPlatformManager(new PlatformManager());
}


LAppLive2DManager::~LAppLive2DManager() 
{
	releaseModel();
	view=NULL;
	Live2D::dispose();
}


void LAppLive2DManager::releaseModel()
{
	for (int i=0; i<models.size(); i++)
	{
		delete models[i];
	}
    models.clear();
}


void LAppLive2DManager::releaseView()
{
	view=NULL;// ARC有効ならばreleaseと同様
}


LAppView* LAppLive2DManager::createView(CGRect &rect)
{
    if(LAppDefine::DEBUG_LOG)NSLog(@"create view x:%.0f y:%.0f width:%.2f height:%.2f",    
                                   rect.origin.x,rect.origin.y,rect.size.width,rect.size.height );
	// Viewの初期化
	releaseView();
    view = (LAppView*)[[LAppView alloc] initWithFrame:rect];
    [view setDelegate:this] ;
    
	return view ;
}


/*
 * モデルの管理状態などの更新。
 * モデルのパラメータなどの更新はdrawで行う。
 * @param gl
 */
void LAppLive2DManager::update()
{
    if(reloadFlg)
	{
		// モデル切り替えボタンが押された時、モデルを再読み込みする
		reloadFlg=false;
        int no = 0;//modelCount % 4;
				
		switch (no)
		{
			case 0:// ハル
				releaseModel();
				models.push_back(new LAppModel());
//                NSString *tPath = [ATools getCachesHaveFile:[NSString stringWithFormat:@"%@/%@", self.detailData.fileName, self.detailData.showJson]];
				//models[0]->load(MODEL_HARU) ;
                if ([ModelFileManager shareInstance].modefFileAllPath) {
                    models[0]->load([[ModelFileManager shareInstance].modefFileAllPath UTF8String]);
                    models[0]->feedIn();
                } else {
                    //[ATools showSVProgressHudCustom:@"" title:@"加载失败"];
                }
                
				break;
			default:
				break;
		}
	}
}


// モデルを追加する
bool LAppLive2DManager::changeModel()
{
	reloadFlg=true;// フラグだけ立てて次回update時に切り替え
	modelCount++;
	return true;
}


/*
 * タップしたときのイベント
 * @param tapCount
 * @return
 */
bool LAppLive2DManager::tapEvent(float x,float y)
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"tapEvent");
	
	for (int i=0; i<models.size(); i++)
	{
		if(models[i]->hitTest(  HIT_AREA_HEAD,x, y ))
		{
			// 顔をタップしたら表情切り替え
			if(LAppDefine::DEBUG_LOG)NSLog( @"tap face");
            NSLog(@"Ares Modify");
            //models[i]->setRandomExpression();
            models[i]->startRandomMotion(MOTION_GROUP_FLICK_HEAD, PRIORITY_NORMAL );
		}
		else if(models[i]->hitTest( HIT_AREA_BODY,x, y))
		{
			if(LAppDefine::DEBUG_LOG)NSLog( @"tap body");
			models[i]->startRandomMotion(MOTION_GROUP_TAP_BODY, PRIORITY_NORMAL );
		}
	}
    return true;
}


/*
 * フリックした時のイベント
 * @param
 * @param
 * @param flickDist
 */
void LAppLive2DManager::flickEvent( float x, float y )
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"flick x:%f y:%f",x,y);
    
    for (int i=0; i<models.size(); i++)
	{
		if(models[i]->hitTest( HIT_AREA_HEAD, x, y ))
		{
			if(LAppDefine::DEBUG_LOG)NSLog( @"flick head");
			models[i]->startRandomMotion(MOTION_GROUP_FLICK_HEAD, PRIORITY_NORMAL );
		}
	}
}


void LAppLive2DManager::maxScaleEvent()
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"max scale event");
	for (int i=0; i<models.size(); i++)
	{
		models[i]->startRandomMotion(MOTION_GROUP_PINCH_IN,PRIORITY_NORMAL );
	}
}


void LAppLive2DManager::minScaleEvent()
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"min scale event");
	for (int i=0; i<models.size(); i++)
	{
		models[i]->startRandomMotion(MOTION_GROUP_PINCH_OUT,PRIORITY_NORMAL );
	}
}


/*
 * シェイクイベント
 */
void LAppLive2DManager::shakeEvent()
{
    if(LAppDefine::DEBUG_LOG)NSLog( @"shake event");
	for (int i=0; i<models.size(); i++)
	{
		models[i]->startRandomMotion(MOTION_GROUP_SHAKE,PRIORITY_FORCE );
	}
}


/*
 * Activityが再開された時のイベント
 */
void LAppLive2DManager::onResume()
{
    if(view!=NULL)[view startAnimation];
}


/*
 * Activityがポーズされた時のイベント
 */
void LAppLive2DManager::onPause()
{
    if(view!=NULL)[view stopAnimation];
}



void LAppLive2DManager::setDrag(float x, float y)
{
	for (int i=0; i<models.size(); i++)
	{
		models[i]->setDrag(x, y);
	}
}


void LAppLive2DManager::setAccel(float x, float y, float z)
{
    for (int i=0; i<models.size(); i++)
	{
		models[i]->setAccel(x, y,z);
	}
}


L2DViewMatrix* LAppLive2DManager::getViewMatrix()
{
	return [view getViewMatrix];
}



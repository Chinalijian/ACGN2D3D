/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#pragma once
//#include <vector>
//#include "type/LDVector.h"
#include "LDVector.h"
#include <math.h>
#include "L2DViewMatrix.h"
@class LAppView;
class LAppModel;

class LAppLive2DManager{
private :
    
	// モデルデータ
	live2d::LDVector<LAppModel*> models;
	
    // OpenGLのView
    LAppView* view ;
	
	//  ボタンから実行できるサンプル機能
	int modelCount;
	bool reloadFlg;// モデル再読み込みのフラグ
public:
    LAppLive2DManager() ;    
    ~LAppLive2DManager() ;
	
    // 解放
	void releaseModel();
	void releaseView();
	
	// 初期化
	void init();
    
	// Live2Dモデル用のOpenGL画面を作成
    LAppView* createView(CGRect &rect);
	LAppView* getView(){return view;}
    
	// 更新
	void update();  
	
	// モデルの取得
    LAppModel* getModel(int no){ return models[no]; }
    int getModelNum(){return models.size();}
    
	// モデルの変更
	bool changeModel();
	
	// 操作によるイベント
    bool tapEvent(float x,float y) ;
    void flickEvent(float x,float y);
    void maxScaleEvent() ;    
    void minScaleEvent() ;
    void shakeEvent() ;
    void onResume();
    void onPause();
    void setDrag(float x, float y);
    void setAccel(float x, float y, float z);
    
	// 画面表示の行列取得
	live2d::framework::L2DViewMatrix* getViewMatrix();
};


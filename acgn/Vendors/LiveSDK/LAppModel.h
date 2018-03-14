/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#pragma once

//Objective C
#import <AVFoundation/AVFoundation.h>

#include "L2DBaseModel.h"

//Live2D Lib
#include "Live2DModelIPhone.h"

//utils
#include "ModelSetting.h"

#include <string>
#include <vector>

class LAppModel : public live2d::framework::L2DBaseModel
{
private:
    ModelSetting*			modelSetting;// 模型的设定
	std::string			modelHomeDir;
   

	AVAudioPlayer*		voice;	// 声音
			
public:
    LAppModel();
    ~LAppModel(void);
    
	// model.jsonの的读取
    void load(const char path[]);
	
	// 其他的读取
	void preloadMotionGroup(const char name[]);
	
	// 更新
    void update();
    void draw();
	
	// モーション
    int startMotion(const char name[],int no,int priority);
	int startRandomMotion(const char name[],int priority);
	
	// 表情
	void setExpression(const char name[]);
	void setRandomExpression();
	
    // 事件的判断
	bool hitTest(const char pid[],float testX,float testY);
	 
	// 音声
	void startVoice( const char fileName[] );
	
	// 表示
	void feedIn();
	
private:
	// 调试用判定的显示
	void drawHitRect();
};







/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */

#pragma once

//C++ std
//#include <string>
//#include <vector>

// 画面
static const float VIEW_MAX_SCALE = 2.0f;
static const float VIEW_MIN_SCALE = 0.8f;

static const float VIEW_LOGICAL_LEFT = -1;
static const float VIEW_LOGICAL_RIGHT = 1;

static const float VIEW_LOGICAL_MAX_LEFT = -2;
static const float VIEW_LOGICAL_MAX_RIGHT = 2;
static const float VIEW_LOGICAL_MAX_BOTTOM = -2;
static const float VIEW_LOGICAL_MAX_TOP = 2;

static const float VIEW_LOGICAL_MAX_BOTTOM_X = -4;
static const float VIEW_LOGICAL_MAX_TOP_X = 4;

// モデル定義------------------------------------------------------------------------
// view的背景图片
static const char BACK_IMAGE_NAME[] = "back_class_normal.png" ;


//模型的定义--
static const char MODEL_HARU[]	= "34/tangli/tangli.model.json";
//static const char MODEL_HARU_A[]        = "live2d/haru/haru_01.model.json";
//static const char MODEL_HARU_B[]        = "live2d/haru/haru_02.model.json";
//static const char MODEL_SHIZUKU[]        = "live2d/shizuku/shizuku.model.json";
//static const char MODEL_WANKO[]       = "live2d/wanko/wanko.model.json";


// 匹配外部文件
static const char MOTION_GROUP_IDLE[]			="idle";        // 眼圈
// Ares Modify
//static const char MOTION_GROUP_TAP_BODY[]        ="";    // 点身体
//static const char MOTION_GROUP_FLICK_HEAD[]        ="";  // 点击头
static const char MOTION_GROUP_TAP_BODY[]        ="tap_body";    // 点身体
static const char MOTION_GROUP_FLICK_HEAD[]        ="flick_head";  // 点击头
static const char MOTION_GROUP_PINCH_IN[]		="pinch_in";    // 扩大
static const char MOTION_GROUP_PINCH_OUT[]		="pinch_out";   // 缩小
static const char MOTION_GROUP_SHAKE[]			="shake";       // 摇动

// 匹配外部文件
static const char HIT_AREA_HEAD[]		="head";
static const char HIT_AREA_BODY[]		="body";

// 动作的优先级
static const int PRIORITY_NONE  = 0;
static const int PRIORITY_IDLE  = 1;
static const int PRIORITY_NORMAL= 2;
static const int PRIORITY_FORCE = 3;


class LAppDefine {
public:
    static const bool DEBUG_LOG=false;// 显示日志
    static const bool DEBUG_TOUCH_LOG=false;// 触摸事件的日志显示
	static const bool DEBUG_DRAW_HIT_AREA=false;// 判断区域的可视化
};

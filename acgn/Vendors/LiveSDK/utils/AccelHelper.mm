/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */

#import "AccelHelper.h"

#import <mach/mach_time.h>
//#include "util/UtSystem.h"
#include "UtSystem.h"

@implementation AccelHelper

static int lastTimeMSec = -1 ;
static double lastMove ;

#define ACCEL_INTERVAL_
#define ACCEL_THREASHOLD (0.1)
#define ACCEL_MODE_IDLING (false)
#define ACCEL_MODE_ACTIVE (true)
#define ACCEL_AVERAGE_COUNT (10)
#define ACCEL_ACTIVE_PERIOD (10)

#define MAX_ACCEL_D (0.1)
#define MAX_SCALE_VALUE 0.4 

static double accelData[ACCEL_AVERAGE_COUNT] ;
static bool accelMode = ACCEL_MODE_IDLING ;
static int accelCounter = 0 ;// 加速度を取得する度にインクリメントする
static int accelActiveModeEnd = ACCEL_AVERAGE_COUNT * 2 ;

static float accelInterval = 1.0 / 10.0 ;

static float acceleration_x = 0 ;
static float acceleration_y = 0 ;
static float acceleration_z = 0 ;
static float dst_acceleration_x = 0 ;
static float dst_acceleration_y = 0 ;
static float dst_acceleration_z = 0 ;

static float last_dst_acceleration_x = 0 ;
static float last_dst_acceleration_y = 0 ;
static float last_dst_acceleration_z = 0 ;

- (void) dealloc
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

//==================================================
// 	加速度センサの更新を取得
//==================================================
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	// 加速度の変化が少ない場合に無視するようにする
	// 一定量変化(ACCEL_THREASHOLD)が無いときは、小さな変化を無視する  ACCEL_IDLING_MODE
	// 一定量以上の変化が発生したあとは、一定期間（ACCEL_ACTIVE_TIME) ACCEL_ACTIVE_MODE として小さな変化も受け付ける
	double curAccelValue = acceleration.x + acceleration.y + acceleration.z ;
	accelData[ (accelCounter++)%ACCEL_AVERAGE_COUNT ] = curAccelValue ;
	double curAccelAve = 0 ;
	for (int i = 0 ; i < ACCEL_AVERAGE_COUNT ; i++ ) curAccelAve += accelData[i] ;
	curAccelAve /= ACCEL_AVERAGE_COUNT ;
	if( fabs( curAccelAve - curAccelValue ) > ACCEL_THREASHOLD )
	{
		accelActiveModeEnd = accelCounter + ACCEL_ACTIVE_PERIOD ;// 一定期間伸ばす
	}
	accelMode = ( accelCounter < accelActiveModeEnd ) ? ACCEL_MODE_ACTIVE : ACCEL_MODE_IDLING ;
	
	if( accelMode == ACCEL_MODE_IDLING ) return ;// アイドリングモードの場合は、加速度変化を反映せずに終了
	
	// 計測された値を前後の値と平均化する
	float scale1 = 0.5 ;
	dst_acceleration_x = dst_acceleration_x * scale1 + acceleration.x * (1-scale1) ;
	dst_acceleration_y = dst_acceleration_y * scale1 + acceleration.y * (1-scale1) ;
	dst_acceleration_z = dst_acceleration_z * scale1 + acceleration.z * (1-scale1) ;
	
	// ---- 以下はぐるぐる用の処理
	double move = 
    fabs(dst_acceleration_x-last_dst_acceleration_x) + 
    fabs(dst_acceleration_y-last_dst_acceleration_y) + 
    fabs(dst_acceleration_z-last_dst_acceleration_z) ;
	lastMove = lastMove * 0.7 + move * 0.3 ;
	
	last_dst_acceleration_x = dst_acceleration_x ;
	last_dst_acceleration_y = dst_acceleration_y ;
	last_dst_acceleration_z = dst_acceleration_z ;
}

//==================================================
// 	加速度センサの値を更新
//==================================================

- (void) update
{
	float dx = dst_acceleration_x - acceleration_x ;
	float dy = dst_acceleration_y - acceleration_y ;
	float dz = dst_acceleration_z - acceleration_z ;
	
	if( dx >  MAX_ACCEL_D ) dx =  MAX_ACCEL_D ;
	if( dx < -MAX_ACCEL_D ) dx = -MAX_ACCEL_D ;
	
	if( dy >  MAX_ACCEL_D ) dy =  MAX_ACCEL_D ;
	if( dy < -MAX_ACCEL_D ) dy = -MAX_ACCEL_D ;
	
	if( dz >  MAX_ACCEL_D ) dz =  MAX_ACCEL_D ;
	if( dz < -MAX_ACCEL_D ) dz = -MAX_ACCEL_D ;
	
	acceleration_x += dx ;
	acceleration_y += dy ;
	acceleration_z += dz ;
	
	long long time = live2d::UtSystem::getTimeMSec() ;
	long long diff = time - lastTimeMSec ;
	lastTimeMSec = time ;
	
	float scale = 0.2 * diff * 60 / (1000.0f) ;	// 経過時間に応じて、重み付けをかえる

	if( scale > MAX_SCALE_VALUE ) scale = MAX_SCALE_VALUE ;
	
	accel[0] = (acceleration_x * scale) + (accel[0] * (1.0 - scale)) ;
	accel[1] = (acceleration_y * scale) + (accel[1] * (1.0 - scale)) ;
	accel[2] = (acceleration_z * scale) + (accel[2] * (1.0 - scale)) ;
}


//==================================================
// Init
//==================================================
- (id) init
{
	if (self = [super init])
	{
		// ------ 加速度センサーを初期化 -------
		UIAccelerometer * _accel = [UIAccelerometer sharedAccelerometer] ;
		[_accel setUpdateInterval:accelInterval] ;
		[_accel setDelegate:self] ;
	}
	return self;
}


/*
 * デバイスを振ったときなどにどのくらい揺れたかを取得。
 * 1を超えるとそれなりに揺れた状態。
 * resetShake()を使ってリセットできる。
 * @return
 */
-(float) getShake{
    return lastMove;
}


/*
 * シェイクイベントが連続で発生しないように揺れをリセットする。
 */
-(void) resetShake{
    lastMove=0;
}


/*
 * 横方向の回転を取得。
 * 寝かせた状態で0。(表裏関係なく)
 * 左に回転させると-1,右に回転させると1になる。
 *
 * @return
 */
-(float) getAccelX {
    return accel[0];
}


/*
 * 上下の回転を取得。
 * 寝かせた状態で0。(表裏関係なく)
 * デバイスが垂直に立っているときに-1、逆さまにすると1になる。
 *
 * @return
 */
-(float) getAccelY{
    return accel[1];
}


/*
 * 上下の回転を取得。
 * 立たせた状態で0。
 * 表向きに寝かせると-1、裏向きに寝かせると1になる
 * @return
 */
-(float) getAccelZ{
    return accel[2];
}

@end

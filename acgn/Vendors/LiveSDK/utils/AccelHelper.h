/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#import <Foundation/Foundation.h>
//-------------------------------------------
//-------------------------------------------
@interface AccelHelper : NSObject <UIAccelerometerDelegate>
{
@private
	UIAccelerationValue accel[3] ;
}

-(void)update;

/*
 * デバイスを振ったときなどにどのくらい揺れたかを取得。
 * 1を超えるとそれなりに揺れた状態。
 * resetShake()を使ってリセットできる。
 * @return
 */
-(float) getShake;

/*
 * シェイクイベントが連続で発生しないように揺れをリセットする。
 */
-(void) resetShake;

/*
 * 横方向の回転を取得。
 * 寝かせた状態で0。(表裏関係なく)
 * 左に回転させると-1,右に回転させると1になる。
 *
 * @return
 */
-(float) getAccelX;

/*
 * 上下の回転を取得。
 * 寝かせた状態で0。(表裏関係なく)
 * デバイスが垂直に立っているときに-1、逆さまにすると1になる。
 *
 * @return
 */
-(float) getAccelY;

/*
 * 上下の回転を取得。
 * 立たせた状態で0。
 * 表向きに寝かせると-1、裏向きに寝かせると1になる
 * @return
 */
-(float) getAccelZ;

@end
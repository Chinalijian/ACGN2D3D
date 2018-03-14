/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#import "IPhoneUtil.h"

@implementation IPhoneUtil

+ (NSString*) toNSString:(std::string&) s
{
    return [[NSString alloc] initWithCString:s.c_str() encoding:NSUTF8StringEncoding];
}


// アプリケーションのバージョンを取得
+ (NSString*) getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}


// ビルドバージョンを取得
+ (NSString*) getBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


+ (int) getTouchNum:(NSSet*)touches
{
    int touchNum = 0 ;
	UITouch * touch_ary[8] ;
	
	for( UITouch * p in touches ){
		touch_ary[touchNum] = p ;
		++touchNum ;		
	}
    return touchNum;
}


// 画面サイズを取得
+ (CGRect) getScreenRect
{
	return [[UIScreen mainScreen] bounds];
}

@end

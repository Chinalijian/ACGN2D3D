/*
 *
 *  You can modify and use this source freely
 *  only for the development of application related Live2D.
 *
 *  (c) Live2D Inc. All rights reserved.
 */
#import <Foundation/Foundation.h>
#include <string>

@interface IPhoneUtil : NSObject

+ (NSString*) toNSString:(std::string&) s;
+ (NSString*) getAppVersion;
+ (NSString*) getBuildVersion;
+ (int) getTouchNum:(NSSet*)touches;
+ (CGRect) getScreenRect;
@end


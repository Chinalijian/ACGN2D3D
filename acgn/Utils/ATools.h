//
//  ATools.h
//  acgn
//
//  Created by Ares on 2018/2/1.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZipArchive.h>
@interface ATools : NSObject
+ (NSString*)MD5:(NSString*)s;
//按钮图片在上，文字再下
+ (void)setButtonContentCenter:(UIButton *)btn;
//计算文字宽度
+(CGFloat)getContactWidth:(NSString*)contact font:(UIFont *)font height:(CGFloat)height;
//成功提示框
+(void)showSVProgressHudCustom:(NSString *)imageName title:(NSString *)title;

//适配iPhone X 顶部与顶部的间距
+ (CGFloat)setViewFrameYForIPhoneX:(CGFloat)y;
+ (CGFloat)setViewFrameBottomForIPhoneX:(CGFloat)b;
+ (CGFloat)setViewFrameHeightToBottomForIPhoneX:(CGFloat)b;
+ (CGFloat)getNavViewFrameHeightForIPhone;
//获取Label的高度，根据文字
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
//获取Label的高度和宽度，根据文字---包含行间距
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font withLineSpacing:(CGFloat)lineSpacing;
+ (CGFloat)getHeightByHeight:(CGFloat)height title:(NSString *)title font:(UIFont*)font;
+ (NSMutableAttributedString *)colerString:(NSString *)sourceStr allStr:(NSString *)allStr color:(UIColor *)color font:(UIFont *)font;
//带有图片的文本
+ (NSMutableAttributedString *)colerString:(NSString *)firstStr secondStr:(NSString *)secondStr allStr:(NSString *)allStr firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor font:(UIFont *)font imageName:(NSString *)imageName imageBounds:(CGRect)rectImage;
//带有图片的文本
+ (NSMutableAttributedString *)colerString:(NSString *)sourceStr allStr:(NSString *)allStr color:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName imageBounds:(CGRect)rectImage isFirstIndex:(BOOL)firstIndex;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 *  NSString转换成NSMutableAttributedString
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
+(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
                                                           text:(NSString *)text
                                                     isEllipsis:(BOOL)isEllipsis ;


//自动解压zip
+ (NSString *)autoUnZipFile:(NSString *)zipFilePath fileName:(NSString *)fileName;
//临时路径
+ (NSString *)tempUnzipPath:(NSString *)fileName;
//获取Caches文件路径
+ (NSString *)getCachesHaveFile:(NSString *)fileName;
//删除文件
+(void)deleteFile:(NSString *)filePath;
//是否已经有此文件
+ (BOOL)fileExistsAtPathForLocal:(NSString *)filePath;

//加载图片
+ (void)loadImageUrlForImageView:(UIImageView *)imageV imageUrl:(NSString *)url;

@end







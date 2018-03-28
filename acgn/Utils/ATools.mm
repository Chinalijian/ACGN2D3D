//
//  ATools.h
//  acgn
//
//  Created by Ares on 2018/2/1.
//  Copyright © 2018年 Jian LI. All rights reserved.
//


#import "ATools.h"
#import <CommonCrypto/CommonDigest.h>
@implementation ATools

+ (NSString*)MD5:(NSString*)s
{
    // Create pointer to the string as UTF8
    const char *ptr = [s UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
   
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

//按钮图片在上，文字再下
+ (void)setButtonContentCenter:(UIButton *)btn {
    
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    //设置按钮内边距
    imgViewSize = btn.imageView.bounds.size;
    titleSize = btn.titleLabel.bounds.size;
    btnSize = btn.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(-heightSpace, 0.0, btnSize.height-imgViewSize.height-heightSpace, -titleSize.width);
    [btn setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height+heightSpace, -imgViewSize.width, 0.0, 0.0);
    [btn setTitleEdgeInsets:titleEdge];
}
//计算文字宽度
+(CGFloat)getContactWidth:(NSString*)contact font:(UIFont *)font height:(CGFloat)height {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    // 计算文字占据的高度
    CGSize size = [contact boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attrs
                                        context:nil].size;
    
    
    return size.width;
    
}
//成功提示框
+(void)showSVProgressHudCustom:(NSString *)imageName title:(NSString *)title {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]]; //字体颜色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];//背景颜色
    [SVProgressHUD setCornerRadius:5];
    
    if (!STR_IS_NIL(imageName)) {
        
        [SVProgressHUD setMinimumSize:CGSizeMake(130, 130)];
        [SVProgressHUD setFont:DMFontPingFang_Regular(16)];
        [SVProgressHUD setImageViewSize:CGSizeMake(62, 62)];
        
    } else {
        
        NSInteger w = [ATools getContactWidth:title font:DMFontPingFang_Regular(18) height:25];
        NSInteger h = 65;
        if (w <= 72) {
            w = 146;
        } else if (w > 200) {
            w = 276;
            h = 95;
        } else {
            w = w+80;
        }
        [SVProgressHUD setMinimumSize:CGSizeMake(w, h)];
        [SVProgressHUD setFont:DMFontPingFang_Regular(18)];
        [SVProgressHUD setImageViewSize:CGSizeMake(0, 0)];
        [SVProgressHUD setRingRadius:40];
        
    }
    [SVProgressHUD showImage:[UIImage imageNamed:imageName] status:title];
}

+ (CGFloat)setViewFrameYForIPhoneX:(CGFloat)y {
    CGFloat H = y;
    if (IS_IPHONE_X) {
        H = H + 20;
    }
    return H;
}
+ (CGFloat)setViewFrameBottomForIPhoneX:(CGFloat)b {
    CGFloat B = b;
    if (IS_IPHONE_X) {
        B = B + 44;
    }
    return B;
}

+ (CGFloat)setViewFrameHeightToBottomForIPhoneX:(CGFloat)b {
    CGFloat B = b;
    if (IS_IPHONE_X) {
        B = B - 44;
    }
    return B;
}

+ (CGFloat)getNavViewFrameHeightForIPhone {
    if (IS_IPHONE_X) {
        return 88;
    }
    return 64;
}

//获取Label的高度和宽度，根据文字
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
//获取Label的高度和宽度，根据文字---包含行间距
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font withLineSpacing:(CGFloat)lineSpacing {
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    //计算文字尺寸
    CGSize size = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    CGFloat height = size.height;
    return height;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
//    label.text = title;
//    label.font = font;
//    label.numberOfLines = 0;
//    [label sizeToFit];
//    CGFloat height = label.frame.size.height;
//    return height;
}

//获取Label的高度和宽度，根据文字
+ (CGFloat)getHeightByHeight:(CGFloat)height title:(NSString *)title font:(UIFont*)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat width1 = label.frame.size.width;
    return width1;
}

+ (NSMutableAttributedString *)colerString:(NSString *)sourceStr allStr:(NSString *)allStr color:(UIColor *)color font:(UIFont *)font {
    NSString *colorString = sourceStr;
    NSString *textString = allStr;
    UIColor *colorStr = color;
    UIFont *fontStr = font;
    NSRange strRange = [textString rangeOfString:colorString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
    
    if (color == nil) {
        //[attributeString setAttributes:@{NSFontAttributeName: fontStr} range:strRange];
    } else {
        [attributeString setAttributes:@{NSFontAttributeName: fontStr, NSForegroundColorAttributeName: colorStr} range:strRange];
    }
    
    return attributeString;
}

+ (NSMutableAttributedString *)colerString:(NSString *)firstStr secondStr:(NSString *)secondStr allStr:(NSString *)allStr firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor font:(UIFont *)font imageName:(NSString *)imageName imageBounds:(CGRect)rectImage {
    
    NSString *firstString = firstStr;
    NSString *secondString = secondStr;
    NSString *textString = allStr;
    
    UIColor *firstColorStr = firstColor;
    UIColor *secondColorStr = secondColor;
    
    UIFont *fontStr = font;
    
    NSRange strFirstRange = [textString rangeOfString:firstString];
    NSRange strSecondRange = [textString rangeOfString:secondString];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
    
    if (firstColorStr == nil) {
        //[attributeString setAttributes:@{NSFontAttributeName: fontStr} range:strRange];
    } else {
        [attributeString setAttributes:@{NSFontAttributeName: fontStr, NSForegroundColorAttributeName: firstColorStr} range:strFirstRange];
    }
    if (secondColorStr == nil) {
        //[attributeString setAttributes:@{NSFontAttributeName: fontStr} range:strRange];
    } else {
        [attributeString setAttributes:@{NSFontAttributeName: fontStr, NSForegroundColorAttributeName: secondColorStr} range:NSMakeRange(firstStr.length, strSecondRange.length)];
    }
    
    if (!STR_IS_NIL(imageName)) {
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:imageName];
        attch.bounds = rectImage;
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attributeString insertAttributedString:string atIndex:firstStr.length];
    }
    
    return attributeString;
}
//带有图片的文本
+ (NSMutableAttributedString *)colerString:(NSString *)sourceStr allStr:(NSString *)allStr color:(UIColor *)color font:(UIFont *)font imageName:(NSString *)imageName imageBounds:(CGRect)rectImage isFirstIndex:(BOOL)firstIndex {
    NSString *colorString = sourceStr;
    NSString *textString = allStr;
    UIColor *colorStr = color;
    UIFont *fontStr = font;
    NSRange strRange = [textString rangeOfString:colorString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
    [attributeString setAttributes:@{NSFontAttributeName: fontStr, NSForegroundColorAttributeName: colorStr} range:strRange];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:imageName];
    attch.bounds = rectImage;
    //创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    if (firstIndex) {
        [attributeString insertAttributedString:string atIndex:0];
    } else {
        [attributeString appendAttributedString:string];
    }
    
    return attributeString;
}
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space{
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}
/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}


/**
 *  NSString转换成NSMutableAttributedString
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
+(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
                                                           text:(NSString *)text isEllipsis:(BOOL)isEllipsis {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    if (isEllipsis) {
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    } else {
        [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    }
    //[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail]; //截断方式，"abcd..."
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [text length])];
    return attributedStr;
}

//自动解压zip
+ (NSString *)autoUnZipFile:(NSString *)zipFilePath fileName:(NSString *)fileName {
    if (!zipFilePath) {
        return nil;
    }
    NSLog(@"待解压的文件路径 = %@", zipFilePath);
    // NSLog(@"9=%@",[[index lastPathComponent] stringByDeletingPathExtension]);
    //NSString *fileName = [NSString stringWithFormat:@"%@/\%@", [], fileName];
    NSString *unzipPath = [self tempUnzipPath:fileName];
    NSLog(@"解压的路径 = %@", unzipPath);
    if (!unzipPath) {
        return nil;
    }
    BOOL success = [SSZipArchive unzipFileAtPath:zipFilePath
                                   toDestination:unzipPath
                              preserveAttributes:YES
                                       overwrite:YES
                                  nestedZipLevel:0
                                        password:nil
                                           error:nil
                                        delegate:nil
                                 progressHandler:nil
                               completionHandler:nil];
    if (success) {
        NSLog(@"Success unzip");
        [self deleteFile:zipFilePath];        
    } else {
        NSLog(@"No success unzip");
        return nil;
    }
    return unzipPath;
    //    NSError *error = nil;
    //    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
    //                                          contentsOfDirectoryAtPath:unzipPath
    //                                          error:&error] mutableCopy];
    //    if (error) {
    //        return;
    //    }
    //    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        switch (idx) {
    //            case 0: {
    //
    //                break;
    //            }
    //            case 1: {
    //
    //                break;
    //            }
    //            case 2: {
    //
    //                break;
    //            }
    //            default: {
    //                NSLog(@"Went beyond index of assumed files");
    //                break;
    //            }
    //        }
    //    }];
    
}
//临时路径
+ (NSString *)tempUnzipPath:(NSString *)fileName {
    //    NSString *path = [NSString stringWithFormat:@"%@/\%@",
    //                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
    //                      fileName];
    NSString *path = [NSString stringWithFormat:@"%@",
                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    if (![@"" isEqualToString:fileName] && fileName != nil) {
        path = [NSString stringWithFormat:@"%@/\%@",
                NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],
                fileName];
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}

+ (NSString *)getCachesHaveFile:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@",
                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    if (![@"" isEqualToString:fileName] && fileName != nil) {
        path = [NSString stringWithFormat:@"%@/\%@",
                NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],
                fileName];
    }
    return path;
}

//删除文件
+(void)deleteFile:(NSString *)filePath {
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}

//是否已经有此文件
+ (BOOL)fileExistsAtPathForLocal:(NSString *)filePath {
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return blHave;
}

//加载图片
+ (void)loadImageUrlForImageView:(UIImageView *)imageV imageUrl:(NSString *)url {
    if (OBJ_IS_NIL(imageV)) {
        return;
    }
    if (STR_IS_NIL(url)) {
        imageV.image = Default_Placeholder_Image;
        return;
    }
    imageV.contentMode = UIViewContentModeCenter;
    NSString * imageUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Default_PlaceholderLoading_Image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            if (image) {
                imageV.image = image;
            } else {
                imageV.image = Default_Placeholder_Image;
            }
        }
    }];
}

@end

























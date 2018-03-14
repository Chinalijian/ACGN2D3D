//
//  ImageCom.h
//  acgn
//
//  Created by lijian on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageComDelegate <NSObject>
@optional
- (void)clickVideoImagePlay:(Info_Type)type videoUrl:(NSString *)videoUrl;
@end
//列表图片/视频的View
@interface ImageCom : UIView
@property (nonatomic, strong) NSString *viedoTime;
@property (nonatomic, weak) id <ImageComDelegate> delegate;
- (id)initWithBigImage:(CGFloat)width
        bigImageHeight:(CGFloat)height
       smallImageWidth:(CGFloat)swidth
      samllImageHeight:(CGFloat)sheight
            smallSpace:(CGFloat)sspace
                frameW:(CGFloat)frameW
                frameH:(CGFloat)frameH;
- (void)configImageCom:(NSArray *)array height:(CGFloat)height type:(Info_Type)type thumbnailUrl:(NSString *)thumbnailUrl;
@end

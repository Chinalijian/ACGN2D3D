//
//  CameraImageViewController.h
//  HaierMall
//
//  Created by lijian on 15-4-28.
//  Copyright (c) 2015年 Haier e Commerce Co., Ltd of Haier Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraImageViewController : UIViewController
-(id)initWithViewController:(UIViewController *)vc isCropper:(BOOL)isCropper;
typedef void (^CameraImageSuccessBlock)(UIImage *headImage);
@property (nonatomic, strong) CameraImageSuccessBlock cameraImageSuccessBlock;
-(void)configureCameraImageSuccessBlock:(CameraImageSuccessBlock)comBlock;
typedef void (^CameraImageCancleBlock)(UIImage *headImage);
@property (nonatomic, strong) CameraImageCancleBlock cameraImageCancleBlock;
-(void)configureCameraImageCancleBlock:(CameraImageCancleBlock)comBlock;
@end

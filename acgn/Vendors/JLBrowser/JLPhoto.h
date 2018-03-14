//
//  JLPhoto.h
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//  展示放大图片的imageView

//#import <UIKit/UIKit.h>

@interface JLPhoto : FLAnimatedImageView //UIImageView
/**
 *  原始imageView
 */
@property (nonatomic,strong) UIImageView *sourceImageView;
/**
 *  大图URL
 */
@property (nonatomic,strong) NSString *bigImgUrl;

//GIF
@property (nonatomic, strong) FLAnimatedImageView *gifSourceImageView;


@end

/*
 FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif"]]];
 FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
 imageView.animatedImage = image;
 imageView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
 [self.view addSubview:imageView];
 */

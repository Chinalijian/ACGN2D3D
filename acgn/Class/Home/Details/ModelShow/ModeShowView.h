//
//  ModeShowView.h
//  acgn
//
//  Created by Ares on 2018/3/13.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModeShowViewDelegate <NSObject>
@optional
- (void)clickModeShowButton:(id)sender;
@end

@interface ModeShowView : UIView
@property (nonatomic, weak) id <ModeShowViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *defaultShowImageView;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *bLeftView;
@property (nonatomic, strong) UIView *bRightView;
@property (nonatomic, strong) UIProgressView *bottomProgressView;
@end

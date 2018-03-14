//
//  SendMsgInputTextView.h
//  acgn
//
//  Created by Ares on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendMsgDeInputDelegate <NSObject>
@optional
- (void)inputContent:(NSString *)content;
- (void)showKeyBoard;
- (void)hiddenKeyBoard;
@end

@interface SendMsgInputTextView : UIView
@property (nonatomic, weak) id <SendMsgDeInputDelegate> delegate;
@property (nonatomic,strong)UIColor *bgColor;   //背景色
@property (nonatomic,assign)BOOL showLimitNum; //显示字数
@property (nonatomic,assign)NSInteger limitNum; //限制字数
@property (nonatomic,strong)UIFont *font;       //文字大小
- (void)rectFrame:(CGRect)rect;
- (void)cleanTextInfo;
@end

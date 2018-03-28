//
//  CommintSecondView.h
//  acgn
//
//  Created by Ares on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>
//列表中二级评论View
@interface CommintSecondView : UIView
- (void)cleanAllSubLabel;
- (void)createCommitLabel:(CGFloat)w;
- (void)hiddenLabel:(NSInteger)count;
- (void)setTotalLabelNumber:(NSInteger)count;

//不包含角色
- (void)setContentForFirstLabel:(NSString *)userName
                      otherName:(NSString *)otherName
                        content:(NSString *)content;
- (void)setContentForSecondLabel:(NSString *)userName
                       otherName:(NSString *)otherName
                         content:(NSString *)content;
- (void)setContentForThirdLabel:(NSString *)userName
                      otherName:(NSString *)otherName
                        content:(NSString *)content;

//包含角色
- (void)setContentForFirstLabelForRole:(NSString *)userName
                             otherName:(NSString *)otherName
                               content:(NSString *)content;
- (void)setContentForSecondLabelForRole:(NSString *)userName
                              otherName:(NSString *)otherName
                                content:(NSString *)content;
- (void)setContentForThirdLabelForRole:(NSString *)userName
                             otherName:(NSString *)otherName
                               content:(NSString *)content;
//
- (void)setContentForFirstLabel:(NSString *)userName
                      otherName:(NSString *)otherName
                        content:(NSString *)content isUserNameNoColor:(BOOL)color; //color来表示userName是否改颜色，YES不改，NO修改
@end

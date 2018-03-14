//
//  ABaseViewController.h
//  acgn
//
//  Created by Ares on 2018/2/1.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABaseViewController : UIViewController
- (void)setNavigationBarTransparence:(BOOL)transparent titleColor:(UIColor *)color;
- (void)setLeftBtn:(CGRect)frame title:(NSString *)title titileColor:(UIColor *)titleColor imageName:(NSString *)imageName font:(UIFont *)font;
- (void)setRigthBtn:(CGRect)frame title:(NSString *)title titileColor:(UIColor *)titleColor imageName:(NSString *)imageName font:(UIFont *)font;
- (void)leftOneAction:(id)sender;
- (void)rightOneAction:(id)sender;
- (void)useMethodToFindBlackLineAndHind:(BOOL)isHidden;
@end

//
//  PopAlertView.h
//  acgn
//
//  Created by lijian on 2018/3/13.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface PopAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;
- (instancetype)initWithTitle:(NSString *)title;
- (void)showXLAlertView;

@end

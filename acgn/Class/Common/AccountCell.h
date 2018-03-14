//
//  AccountCell.h
//  acgn
//
//  Created by Ares on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockClickTextField)(BOOL displayKeyBoard);

@interface AccountCell : UITableViewCell
@property (nonatomic, strong) BlockClickTextField clickTextFieldBlock;
@property (nonatomic, strong) UIView *bgView;
- (void)configInfo:(AccountLocalDataModel *)obj;
- (void)textSwitchSecure:(BOOL)s;
@end

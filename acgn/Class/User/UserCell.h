//
//  UserCell.h
//  acgn
//
//  Created by lijian on 2018/2/3.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *redPointLabel;
- (void)configInfo:(NSString *)imageName title:(NSString *)title;
@end

//
//  SendTableViewCell.h
//  acgn
//
//  Created by Ares on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendTableViewCell : UITableViewCell
- (void)configDynamicObj:(DynamicCommentListData *)obj;
+ (CGFloat)getCellMaxHeightAndUpdate:(DynamicCommentListData *)dynamicObj;
@end

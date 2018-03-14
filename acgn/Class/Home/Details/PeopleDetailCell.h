//
//  PeopleDetailCell.h
//  acgn
//
//  Created by Ares on 2018/2/11.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PeopleDetailCellDelegate <NSObject>
@optional
- (void)userClickFabulousPraise:(id)sender;
- (void)userClickVideo:(Info_Type)type videoUrl:(NSString *)videoUrl;
@end
@interface PeopleDetailCell : UITableViewCell
@property (nonatomic, weak) id <PeopleDetailCellDelegate> delegate;
+ (CGFloat)getPeopleDetailCellHeight:(RoleDetailsPostData *)obj;
- (void)configInfo:(RoleDetailsPostData *)obj;
@end

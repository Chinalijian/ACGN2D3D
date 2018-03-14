//
//  PeopleDetailHeader.h
//  acgn
//
//  Created by Ares on 2018/2/11.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PeopleDetailHeaderDelegate <NSObject>
@optional
- (void)clickSelectPeopleImage:(NSString *)roleId;
- (void)clickClickAttBtn:(id)sender;
- (void)clickGotoModeShow:(id)sender;
@end

//列表头的通用控件View
@interface PeopleDetailHeader : UIView
- (id)initWithframe:(CGRect)frame;
@property (nonatomic, weak) id <PeopleDetailHeaderDelegate> delegate;
- (void)configInfo:(RoleDetailsDataModel *)obj;
+ (CGFloat)getViewTotalHeight:(RoleDetailsDataModel *)obj;
- (void)updateAttBtn:(BOOL)isAtt;
@end

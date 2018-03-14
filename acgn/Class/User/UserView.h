//
//  UserView.h
//  acgn
//
//  Created by lijian on 2018/2/3.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserViewDelegate <NSObject>
@optional
- (void)clickTopGotoLogin;
- (void)clickTopGotoNikeNamePage;
- (void)goToPage:(AAccountType)type;
- (void)clickLogoutSystem;
@end

@interface UserView : UIView
@property (nonatomic, strong) UITableView *uTableView;
@property (nonatomic, assign) BOOL hasNoMsg;
@property (nonatomic, weak) id <UserViewDelegate> delegate;
- (void)updateUserInfo;
@end

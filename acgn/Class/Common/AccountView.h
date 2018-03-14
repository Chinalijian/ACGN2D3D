//
//  AccountView.h
//  acgn
//
//  Created by Ares on 2018/2/2.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountViewDelegate <NSObject>
@optional
- (void)clickAccountSure:(id)sender datas:(NSMutableArray *)array;
- (void)clickAccountRegister:(id)sender;
- (void)clickAccountResetPsd:(id)sender;
- (void)clickThirdPartyQQ:(id)sender;
- (void)clickThirdPartyWecat:(id)sender;
- (void)clickThirdPartyWeibo:(id)sender;
- (void)clickGetCode:(id)sender obj:(AccountLocalDataModel *)obj;
- (void)clickCameraForUser:(id)sender;
@end

@interface AccountView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *aTableView;
@property (nonatomic, weak) id <AccountViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame type:(AAccountType)type;

//update headUrl or nickName
- (void)updateHeadUrlAndNickName;

@end

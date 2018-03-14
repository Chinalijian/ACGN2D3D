//
//  AttentionPeopleList.h
//  acgn
//
//  Created by Ares on 2018/2/1.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttentionPeopleListDelegate <NSObject>
- (void)clickAttentButton:(id)sender;
- (void)clickSelectedPeople:(BOOL)follow roleId:(NSString *)roleId;
@end

@interface AttentionPeopleList : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *aTableView;
@property (nonatomic, weak) id <AttentionPeopleListDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *datas;
- (id)initWithFrame:(CGRect)frame delegate:(id<AttentionPeopleListDelegate>) delegate;
- (void)updateList:(NSMutableArray *)array;
@end

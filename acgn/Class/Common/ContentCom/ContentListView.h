//
//  ContentListView.h
//  acgn
//
//  Created by Ares on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentListDelegate <NSObject>
@optional
- (void)clickSelectRowAtIndexPath:(id)obj;
- (void)clickPeopleHead:(NSString *)roleID;
- (void)clickSelectRowAtIndexPathForCommit:(id)obj;
- (void)clickPraiseUser:(id)sender;
- (void)clickPraiseFabulous:(id)sender view:(id)viewSelf;
- (void)clickFavUser:(id)sender view:(id)viewSelf;
- (void)clickAttForUser:(id)sender view:(id)viewSelf;
- (void)tempNavigationBarShowHidden:(UIScrollView *)scrollView;
- (void)clickVideoListPlay:(Info_Type)type videoUrl:(NSString *)videoUrl;
@end

@interface ContentListView : UIView
@property (nonatomic, strong) UITableView *aTableView;
@property (nonatomic, weak) id <ContentListDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) BOOL isFavPage;
@property (nonatomic, assign) ContentCom_Type ccType;
- (id)initWithFrame:(CGRect)frame delegate:(id<ContentListDelegate>) delegate withType:(ContentCom_Type)ccType;
- (void)updateList:(NSMutableArray *)array;
- (void)updateFabulous;
- (void)detailsCommit;
@end

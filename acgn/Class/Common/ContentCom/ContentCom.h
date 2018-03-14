//
//  ContentCom.h
//  acgn
//
//  Created by lijian on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCom.h"


@protocol ContentComDelegate <NSObject>
@optional
- (void)clickSelectPeopleImage:(NSString *)roleId;
- (void)clickSelectSectionViewForGoToDetail:(id)obj;
- (void)clickPraiseFabulous:(id)sender view:(id)viewSelf;
- (void)clickFavForUser:(id)sender view:(id)viewSelf;
- (void)clickAttForUser:(id)sender view:(id)viewSelf;
- (void)clickVideoPlay:(Info_Type)type videoUrl:(NSString *)videoUrl;
@end


//列表头的通用控件View
@interface ContentCom : UITableViewHeaderFooterView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame contentComType:(ContentCom_Type)type;
@property (nonatomic, weak) id <ContentComDelegate> delegate;
- (void)configInfo:(DynamicListData *)obj;
+ (CGFloat)getContentCommonCellHeight:(DynamicListData *)obj contentType:(ContentCom_Type)type;
- (void)updateFabulous;
- (void)updateCollectionView;
- (void)updateAttentView;
@end

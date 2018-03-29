//
//  ContentListCell.h
//  acgn
//
//  Created by Ares on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Content_List_Cell_H 80//90 //cell的默认高度
#define Top_Space_Y     13.5    //距离上部的间距
#define Left_Space_X    16      //距离左边的间距
#define Head_Image_WH   33      //头像的宽高
#define Label_Space_X   6.5     //Label的x距离 头像的间距
#define Bottom_Area_H   44      //距离底部间距
#define Label_Space_Y   10      //Label之间的上下边距

#define SecondView_Top_SPace_Y 15 //二级评论的上下间距
#define SecondView_LeftRight_SPace 10 //二级评论的左右间距

#define NameLabel_H     15


#define Info_Width DMScreenWidth-Head_Image_WH-Label_Space_X-Left_Space_X*2 //评论内容label的宽度

@protocol ContentListCellDelegate <NSObject>
@optional
- (void)userClickPraise:(id)sender;
@end

@interface ContentListCell : UITableViewCell
@property (nonatomic, weak) id <ContentListCellDelegate> delegate;
- (void)configDynamicObj:(DynamicCommentListData *)obj;
- (void)configDynamicObj:(DynamicCommentListData *)obj msgDetails:(BOOL)msgDetailPage index:(NSInteger)index;
+ (CGFloat)getCellMaxHeightAndUpdate:(DynamicCommentListData *)dynamicObj;
@end

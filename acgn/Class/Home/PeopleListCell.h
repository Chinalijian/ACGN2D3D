//
//  PeopleListCell.h
//  acgn
//
//  Created by lijian on 2018/2/6.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleListDataModel.h"
#import "PeopleSubView.h"
#define People_List_Cell_H 316
@interface PeopleListCell : UITableViewCell
@property (nonatomic, strong) PeopleSubView *leftView;
@property (nonatomic, strong) PeopleSubView *rightView;
- (void)configPeopleInfo:(PeopleDataModel *)objL objRight:(PeopleDataModel *)objR;
@end

//
//  PeopleSubView.h
//  acgn
//
//  Created by lijian on 2018/2/6.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleSubView : UIView
@property (nonatomic, strong) UIImageView *peopleImageView;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;

@property (nonatomic, strong) UIButton *selectedBtn;

@end

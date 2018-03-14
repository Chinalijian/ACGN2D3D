//
//  ComonTop.m
//  acgn
//
//  Created by lijian on 2018/2/4.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ComonTop.h"

@implementation ComonTop
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    [self addSubview:self.topImageView];
    [self setupMakeTopViewSubViewsLayout];
}

- (void)setupMakeTopViewSubViewsLayout {
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topImageView).mas_offset([ATools setViewFrameYForIPhoneX:80]);
        make.height.mas_offset(70.5);
        make.width.mas_offset(70.5);
        make.centerX.mas_equalTo(_topImageView);
    }];
    [_logoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_logoImageView.mas_bottom).mas_offset(1);
        make.left.mas_equalTo(_topImageView).mas_offset(0);
        make.right.mas_equalTo(_topImageView).mas_offset(0);
        make.bottom.mas_equalTo(_topImageView).mas_offset(-2);
    }];
}

- (UIImageView *)topImageView {
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _topImageView.image = [UIImage imageNamed:@"public_head"];
        _topImageView.userInteractionEnabled = YES;
        [_topImageView addSubview:self.logoImageView];
        [_topImageView addSubview:self.logoNameLabel];
    }
    return _topImageView;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"public_logo"];
        _logoImageView.userInteractionEnabled = YES;
    }
    return _logoImageView;
}

- (UILabel *)logoNameLabel {
    if (_logoNameLabel == nil) {
        _logoNameLabel = [[UILabel alloc] init];
        _logoNameLabel.text = @"";
        _logoNameLabel.textAlignment = NSTextAlignmentCenter;
        _logoNameLabel.textColor = [UIColor whiteColor];
        _logoNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _logoNameLabel;
}

@end

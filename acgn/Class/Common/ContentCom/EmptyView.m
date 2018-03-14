//
//  EmptyView.m
//  acgn
//
//  Created by Ares on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *bButton;

@end

@implementation EmptyView

- (id)initWithFrame:(CGRect)frame delegate:(id<EmptyViewDelegate>) delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        
        [self loadUI];
    }
    return self;
}

- (void)clickBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickEmptyButton:)]) {
        [self.delegate clickEmptyButton:sender];
    }
}

- (void)updateInfo:(NSString *)imageName title:(NSString *)title btnTitle:(NSString *)btnTitle {
    self.topImageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
    if (!STR_IS_NIL(btnTitle)) {
        self.bButton.hidden = NO;
        [self.bButton setTitle:btnTitle forState:UIControlStateNormal];
    }
}

- (void)loadUI {
    [self addSubview:self.topImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.bButton];
    [self setupSubLayout];
}

- (void)setupSubLayout {
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(36);
        make.centerX.mas_equalTo(self);
        make.width.mas_offset(70);
        make.height.mas_offset(56);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topImageView.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.height.mas_offset(15);
    }];
    [self.bButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(self);
        make.width.mas_offset(102);
        make.height.mas_offset(40);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)topImageView {
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.alpha = .5;
    }
    return _topImageView;
}

- (UIButton *)bButton {
    if (_bButton == nil) {
        _bButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bButton.backgroundColor =UIColorFromRGB(0xE96A79);
        [_bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_bButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _bButton.layer.cornerRadius = 20;
        _bButton.hidden = YES;
    }
    return _bButton;
}



@end









//
//  PeopleSubView.m
//  acgn
//
//  Created by lijian on 2018/2/6.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "PeopleSubView.h"

@implementation PeopleSubView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    [self addSubview:self.peopleImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.fansLabel];
    [self addSubview:self.selectedImageView];
    [self addSubview:self.lineLabel];
    [self addSubview:self.selectedBtn];
    [self setupMakeTopViewSubViewsLayout];
}

- (void)setupMakeTopViewSubViewsLayout {
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(30);
//        make.left.mas_equalTo(self).mas_offset(26);//26
//        make.right.mas_equalTo(self.mas_right).mas_offset(-26);
        make.height.mas_offset(186.5);
        make.width.mas_offset(138.5);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_peopleImageView.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(21);
        make.right.mas_equalTo(self.mas_right).mas_offset(-21);
        make.height.mas_offset(.5);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(21);
        make.right.mas_equalTo(self.mas_right).mas_offset(-21);
        make.height.mas_offset(15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(_nameLabel).mas_offset(0);
        make.right.mas_equalTo(_nameLabel).mas_offset(0);
        make.height.mas_offset(12);
    }];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(_titleLabel).mas_offset(0);
        make.right.mas_equalTo(_titleLabel).mas_offset(0);
        make.height.mas_offset(12);
    }];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_fansLabel.mas_bottom).mas_offset(10);
//        make.left.mas_equalTo(self).mas_offset(84);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-84);
        make.width.mas_offset(30);
        make.height.mas_offset(30);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_peopleImageView).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(0);
        make.right.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self.selectedImageView.mas_bottom).mas_offset(0);
    }];
}

- (UIImageView *)peopleImageView {
    if (_peopleImageView == nil) {
        _peopleImageView = [[UIImageView alloc] init];
        _peopleImageView.clipsToBounds = YES;
        _peopleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _peopleImageView;
}

- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = UIColorFromRGB(0xE96A79);
    }
    return _lineLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = UIColorFromRGB(0xE96A79);
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x000000);
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

- (UILabel *)fansLabel {
    if (_fansLabel == nil) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.text = @"";
        _fansLabel.textAlignment = NSTextAlignmentCenter;
        _fansLabel.textColor = UIColorFromRGB(0x000000);
        _fansLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fansLabel;
}

- (UIImageView *)selectedImageView {
    if (_selectedImageView == nil) {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.clipsToBounds = YES;
        _selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _selectedImageView;
}

- (UIButton *)selectedBtn {
    if (_selectedBtn == nil) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.backgroundColor = [UIColor clearColor];
    }
    return _selectedBtn;
}


@end

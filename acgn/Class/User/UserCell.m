//
//  UserCell.m
//  acgn
//
//  Created by lijian on 2018/2/3.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "UserCell.h"

@interface UserCell ()

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation UserCell
#define User_TableViewCell_H 65
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    return self;
}

- (void)configInfo:(NSString *)imageName title:(NSString *)title {
    self.titleImageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
}

#pragma mark - UI
- (void)loadUI {
    [self addSubview:self.titleImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.redPointLabel];
    [self setupMakeBodyViewSubViewsLayout];
}

- (void)setupMakeBodyViewSubViewsLayout {
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset((User_TableViewCell_H-30.5)/2);
        make.left.mas_equalTo(self).mas_offset(20);
        make.width.mas_equalTo(30.5);
        make.height.mas_equalTo(30.5);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleImageView).mas_offset(0);
        make.left.mas_equalTo(_titleImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-47);
        make.bottom.mas_equalTo(_titleImageView).mas_offset(0);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(0);
        make.right.mas_equalTo(self).mas_offset(-20);
        make.bottom.mas_equalTo(self).mas_offset(0);
        make.width.mas_equalTo(50);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-0.5);
        make.height.mas_offset(0.5);
    }];
    [_redPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(_titleImageView.mas_right).mas_offset(75);
        make.width.mas_offset(7);
        make.height.mas_offset(7);
    }];
}

- (UIImageView *)titleImageView {
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.clipsToBounds = YES;
        _titleImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _titleImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.hidden = YES;
    }
    return _rightLabel;
}

- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = UIColorFromRGB(0xC3C3C3);
    }
    return _lineLabel;
}

- (UILabel *)redPointLabel {
    if (_redPointLabel == nil) {
        _redPointLabel = [[UILabel alloc] init];
        _redPointLabel.backgroundColor = UIColorFromRGB(0xFF0000);
        _redPointLabel.layer.cornerRadius = 3.5;
    }
    return _redPointLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

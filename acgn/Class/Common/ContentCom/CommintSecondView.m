//
//  CommintSecondView.m
//  acgn
//
//  Created by Ares on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "CommintSecondView.h"

@interface CommintSecondView()
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, assign) CGFloat widthLabel;
@end

@implementation CommintSecondView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
- (void)cleanAllSubLabel {
    self.firstLabel.text = @"";
    self.secondLabel.text = @"";
    self.thirdLabel.text = @"";
}
- (void)createCommitLabel:(CGFloat)w {
    self.widthLabel = w;
    [self addSubview:self.firstLabel];
    [self addSubview:self.secondLabel];
    [self addSubview:self.thirdLabel];
    [self setupLabelLayout];
}
- (void)setContentForFirstLabel:(NSString *)userName
                      otherName:(NSString *)otherName
                        content:(NSString *)content isUserNameNoColor:(BOOL)color {
    [self getColorStr:userName otherName:otherName content:content label:self.firstLabel isUserNameNoColor:color];
}
- (void)setContentForFirstLabel:(NSString *)userName
                      otherName:(NSString *)otherName
                        content:(NSString *)content {
    [self getColorStr:userName otherName:otherName content:content label:self.firstLabel];
}
- (void)setContentForSecondLabel:(NSString *)userName
                       otherName:(NSString *)otherName
                         content:(NSString *)content {
    [self getColorStr:userName otherName:otherName content:content label:self.secondLabel];
}
- (void)setContentForThirdLabel:(NSString *)userName
                      otherName:(NSString *)otherName
                        content:(NSString *)content {
    [self getColorStr:userName otherName:otherName content:content label:self.thirdLabel];
}

- (void)getColorStr:(NSString *)userName
                                 otherName:(NSString *)otherName
                                   content:(NSString *)content label:(UILabel *)label {
    NSString *colorStr = [NSString stringWithFormat:@"%@ @%@：",userName,otherName];
    NSString *contentAll = [NSString stringWithFormat:@"%@ @%@：%@",userName,otherName,content];
    NSMutableAttributedString *str = [ATools colerString:colorStr allStr:contentAll color:UIColorFromRGB(0xE96A79) font: [UIFont systemFontOfSize:13]];
    CGFloat H = [self getContentHeight:contentAll];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(H);
    }];
    label.attributedText = str;
}

- (void)getColorStr:(NSString *)userName
          otherName:(NSString *)otherName
            content:(NSString *)content label:(UILabel *)label isUserNameNoColor:(BOOL)color {
    
    if (STR_IS_NIL(userName) && STR_IS_NIL(otherName)) {
        NSString *colorStr = @"";
        NSMutableAttributedString *str = [ATools colerString:colorStr allStr:content color:UIColorFromRGB(0xE96A79) font: [UIFont systemFontOfSize:13]];
        CGFloat H = [self getContentHeight:content];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(H);
        }];
        label.attributedText = str;
        return;
    }
    NSString *colorStr = @"";
    NSString *contentAll = @"";
    if (color) {
        if (STR_IS_NIL(userName)) {
            colorStr = otherName;
            contentAll = [NSString stringWithFormat:@"%@：%@",otherName,content];
        } else {
            colorStr = [NSString stringWithFormat:@"@%@：",otherName];
            contentAll = [NSString stringWithFormat:@"%@ @%@：%@",userName,otherName,content];
        }
    } else {
        colorStr = [NSString stringWithFormat:@"%@ @%@：",userName,otherName];
    }
    NSMutableAttributedString *str = [ATools colerString:colorStr allStr:contentAll color:UIColorFromRGB(0xE96A79) font: [UIFont systemFontOfSize:13]];
    CGFloat H = [self getContentHeight:contentAll];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(H);
    }];
    label.attributedText = str;
}


- (CGFloat)getContentHeight:(NSString *)content {
    if (STR_IS_NIL(content)) {
        return 0;
    }
    CGFloat H = [ATools getHeightByWidth:self.widthLabel-20 title:content font: [UIFont systemFontOfSize:13]];
    return H;
}


- (void)hiddenLabel:(NSInteger)count {
    if (count == 1) {
        self.firstLabel.hidden = NO;
        self.secondLabel.hidden = YES;
        self.thirdLabel.hidden = YES;
    } else if (count == 2) {
        self.firstLabel.hidden = NO;
        self.secondLabel.hidden = NO;
        self.thirdLabel.hidden = YES;
    } else {
        self.firstLabel.hidden = NO;
        self.secondLabel.hidden = NO;
        self.thirdLabel.hidden = NO;
    }
}

- (void)setupLabelLayout {
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(15);
        make.left.mas_equalTo(self).mas_offset(10);
        make.width.mas_offset(self.widthLabel-20);
        make.height.mas_offset(15);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_firstLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self).mas_offset(10);
        make.width.mas_offset(self.widthLabel-20);
        make.height.mas_offset(15);
    }];
    [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_secondLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(self).mas_offset(10);
        make.width.mas_offset(self.widthLabel-20);
        make.height.mas_offset(15);
    }];
}

- (UILabel *)firstLabel {
    if (_firstLabel == nil) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.text = @"";
        _firstLabel.textAlignment = NSTextAlignmentLeft;
        _firstLabel.textColor = UIColorFromRGB(0x000000);
        _firstLabel.font = [UIFont systemFontOfSize:13];
        _firstLabel.lineBreakMode = NSLineBreakByClipping;
        _firstLabel.numberOfLines = 0;
    }
    return _firstLabel;
}
- (UILabel *)secondLabel {
    if (_secondLabel == nil) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.text = @"";
        _secondLabel.textAlignment = NSTextAlignmentLeft;
        _secondLabel.textColor = UIColorFromRGB(0x000000);
        _secondLabel.font = [UIFont systemFontOfSize:13];
        _secondLabel.lineBreakMode = NSLineBreakByClipping;
        _secondLabel.numberOfLines = 0;
    }
    return _secondLabel;
}
- (UILabel *)thirdLabel {
    if (_thirdLabel == nil) {
        _thirdLabel = [[UILabel alloc] init];
        _thirdLabel.text = @"";
        _thirdLabel.textAlignment = NSTextAlignmentLeft;
        _thirdLabel.textColor = UIColorFromRGB(0x000000);
        _thirdLabel.font = [UIFont systemFontOfSize:13];
        _thirdLabel.lineBreakMode = NSLineBreakByClipping;
        _thirdLabel.numberOfLines = 0;
    }
    return _thirdLabel;
}

//- (void)loadUI {
//    [self addSubview:self.contentLabel];
//}
//
//- (UILabel *)contentLabel {
//    if (_contentLabel == nil) {
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.text = @"";
//        _contentLabel.textAlignment = NSTextAlignmentLeft;
//        _contentLabel.textColor = UIColorFromRGB(0x000000);
//        _contentLabel.font = [UIFont systemFontOfSize:13];
//    }
//    return _contentLabel;
//}

@end

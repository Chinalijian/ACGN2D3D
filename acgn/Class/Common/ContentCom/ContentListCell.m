//
//  ContentListCell.m
//  acgn
//
//  Created by Ares on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ContentListCell.h"
#import "CommintSecondView.h"

@interface ContentListCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commitLabel;

@property (nonatomic, strong) CommintSecondView *secondView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *praiseLabel;

@property (nonatomic, strong) DynamicCommentListData *cellObj;
@property (nonatomic, strong) UILabel *lineLabel;
@end

@implementation ContentListCell
#define Default_Show_Count 3
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    return self;
}

- (void)clickPraise:(id)sender {
    if ([self.delegate respondsToSelector:@selector(userClickPraise:)]) {
        [self.delegate userClickPraise:self.cellObj];
    }
}

- (void)cleanSubViewInfo {
    self.headImageView.image = nil;
    self.nameLabel.text = @"";
    self.commitLabel.text = @"";
    self.timeLabel.text = @"";
    [self.praiseLabel setTitle:@"" forState:UIControlStateNormal];
    [self.secondView cleanAllSubLabel];
}

- (void)configDynamicObj:(DynamicCommentListData *)obj msgDetails:(BOOL)msgDetailPage index:(NSInteger)index {
    if (msgDetailPage) {
        //吐槽详情
        self.cellObj = obj;
        [self cleanSubViewInfo];
        if (!OBJ_IS_NIL(obj)) {
            if (index == 0) {
                [self setFirstUserNameInfo:obj];
            } else {
                [self setSecondUserNameInfo:obj];
            }
            [self setSubObjInfo:obj];
        }
    } else {
        [self configDynamicObj:obj];
    }
}

- (void)configDynamicObj:(DynamicCommentListData *)obj {
    self.cellObj = obj;
    [self cleanSubViewInfo];
    if (!OBJ_IS_NIL(obj)) {
        [self setFirstUserNameInfo:obj];
        [self setSubObjInfo:obj];
    }
}

- (void)setFirstUserNameInfo:(DynamicCommentListData *)obj {
    NSString *imageUrl = [obj.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Default_Placeholder_Image];
    if (obj.isRole.intValue == 1) {
        NSMutableAttributedString *str = [ATools colerString:obj.userName allStr:obj.userName color:UIColorFromRGB(0x3580E6) font: [UIFont systemFontOfSize:13] imageName:@"jiaose_icon" imageBounds:CGRectMake(0, -2, NameLabel_H, NameLabel_H) isFirstIndex:YES];
        self.nameLabel.attributedText = str;
    } else {
        self.nameLabel.text = obj.userName;
    }
}

- (void)setSecondUserNameInfo:(DynamicCommentListData *)obj {
    NSString *imageUrl = [obj.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Default_Placeholder_Image];
    if (obj.secondIsRole.intValue == 1) {
        NSString *colorUserNameStr = STR_IS_NIL(obj.otherName)?[NSString stringWithFormat:@"%@",obj.userName]:[NSString stringWithFormat:@"%@ @ ",obj.userName];
        NSString *colorOtherNameStr = STR_IS_NIL(obj.otherName)?@"":[NSString stringWithFormat:@"%@",obj.otherName];
        NSString *contentAll = [NSString stringWithFormat:@"%@%@",colorUserNameStr,colorOtherNameStr];
        NSMutableAttributedString *str = [ATools colerString:colorUserNameStr secondStr:colorOtherNameStr allStr:contentAll firstColor:UIColorFromRGB(0xE96A79) secondColor:UIColorFromRGB(0x3580E6) font:[UIFont systemFontOfSize:13] imageName:@"jiaose_icon" imageBounds:CGRectMake(0, -4, 16, 16)];
        self.nameLabel.attributedText = str;
    } else {
        self.nameLabel.text = STR_IS_NIL(obj.otherName)? obj.userName : [NSString stringWithFormat:@"%@ @ %@", obj.userName, obj.otherName];
    }
}

- (void)setSubObjInfo:(DynamicCommentListData *)obj {
    self.commitLabel.text = obj.commentContext;
    self.timeLabel.text = obj.commentTime;
    if (obj.localPraise) {
        [_praiseLabel setImage:[UIImage imageNamed:@"praise_yellow_icon"] forState:UIControlStateNormal];
    } else {
        [_praiseLabel setImage:[UIImage imageNamed:@"praise_grey_icon"] forState:UIControlStateNormal];
    }
    [self.praiseLabel setTitle:obj.praiseNum forState:UIControlStateNormal];
    if (obj.secondView.count > 0) {
        NSInteger count = obj.secondView.count;
        [self.secondView hiddenLabel:count];
        if (count == 1) {
            DynamicCommentSecondData *csData = [obj.secondView firstObject];
            [self setSecondViewFirstInfo:csData];
        } else if (count == 2) {
            DynamicCommentSecondData *csData1 = [obj.secondView firstObject];
            [self setSecondViewFirstInfo:csData1];
            DynamicCommentSecondData *csData2 = [obj.secondView lastObject];
            [self setSecondViewSecondInfo:csData2];
        } else {
            DynamicCommentSecondData *csData1 = [obj.secondView firstObject];
            [self setSecondViewFirstInfo:csData1];
            DynamicCommentSecondData *csData2 = [obj.secondView objectAtIndex:1];
            [self setSecondViewSecondInfo:csData2];
            DynamicCommentSecondData *csData3 = [obj.secondView objectAtIndex:2];
            [self setSecondViewThirdInfo:csData3];
        }
        if (obj.commentNum.integerValue > Default_Show_Count) {
            [self.secondView setTotalLabelNumber:obj.commentNum.integerValue];
        }
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        }];
        [self.praiseLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-0);
        }];
    } else {
        [self.secondView hiddenLabel:0];
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
        [self.praiseLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        }];
    }
    
    CGFloat commitH = [ContentListCell getCommitContentMaxHeight:obj];
    CGFloat secondH = [ContentListCell getSecondViewMaxHeight:obj];
    [self upDateCellLayout:commitH secondHeight:secondH];
    [self updateCommitContentFrame:commitH];
    [self updateSecondCommitViewFrame:secondH];
    [self layoutIfNeeded];
}

- (void)setSecondViewFirstInfo:(DynamicCommentSecondData *)csData {
    if (csData.secondIsRole.integerValue == 1) {
        [self.secondView setContentForFirstLabelForRole:csData.userName otherName:csData.otherName content:csData.commentContext];
    } else {
        [self.secondView setContentForFirstLabel:csData.userName otherName:csData.otherName content:csData.commentContext];
    }

}
- (void)setSecondViewSecondInfo:(DynamicCommentSecondData *)csData {
    if (csData.secondIsRole.integerValue == 1) {
        [self.secondView setContentForSecondLabelForRole:csData.userName otherName:csData.otherName content:csData.commentContext];
    } else {
        [self.secondView setContentForSecondLabel:csData.userName otherName:csData.otherName content:csData.commentContext];
    }
}
- (void)setSecondViewThirdInfo:(DynamicCommentSecondData *)csData {
    if (csData.secondIsRole.integerValue == 1) {
        [self.secondView setContentForThirdLabelForRole:csData.userName otherName:csData.otherName content:csData.commentContext];
    } else {
        [self.secondView setContentForThirdLabel:csData.userName otherName:csData.otherName content:csData.commentContext];
    }
}

- (void)upDateCellLayout:(CGFloat)commitH secondHeight:(CGFloat)secondH {
    CGFloat heightRow = Content_List_Cell_H + commitH + secondH;
    self.frame = CGRectMake(0, 0, DMScreenWidth, heightRow);
}

- (void)updateCommitContentFrame:(CGFloat)commitH {
    [self.commitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left).offset(0);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(Label_Space_Y);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(commitH);
    }];
}

- (void)updateSecondCommitViewFrame:(CGFloat)secondH {
    [self.secondView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left).offset(0);
        make.top.mas_equalTo(_commitLabel.mas_bottom).offset(SecondView_Top_SPace_Y);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(secondH);
    }];
}

+ (CGFloat)getCellMaxHeightAndUpdate:(DynamicCommentListData *)dynamicObj {
    CGFloat commitH = [self getCommitContentMaxHeight:dynamicObj];
    CGFloat secondH = [self getSecondViewMaxHeight:dynamicObj];
    CGFloat heightRow = Content_List_Cell_H + commitH + (secondH>0?secondH+10:secondH);
    return heightRow;
}

+ (CGFloat)getCommitContentMaxHeight:(DynamicCommentListData *)dynamicObj {
    if (OBJ_IS_NIL(dynamicObj)) {
        return 0;
    }
    return [ATools getHeightByWidth:Info_Width title:dynamicObj.commentContext font:Commit_Font];
}

+ (CGFloat)getSecondViewMaxHeight:(DynamicCommentListData *)dynamicObj {
  
    if (!OBJ_IS_NIL(dynamicObj)) {
        CGFloat commitSecond = 0;
        NSInteger count = dynamicObj.secondView.count;
        if (count > 0) {
            CGFloat commitListH = 0;//
            if (dynamicObj.commentNum.integerValue > Default_Show_Count) {
                commitListH = 15*4 + 28;
            } else {
                commitListH = 15 * (count+1);
            }
            for (int i = 0; i < count; i++) {
                DynamicCommentSecondData *seObj = [dynamicObj.secondView objectAtIndex:i];
                
                if (seObj.secondIsRole.integerValue == 1) {
//                    [content stringByAppendingString:@"        "];
                    NSString *content = [NSString stringWithFormat:@"%@ @ %@：%@",seObj.userName,seObj.otherName,seObj.commentContext];
//                    CGFloat h = [ATools getHeightByWidth:Info_Width-SecondView_LeftRight_SPace*2-16 title:content font:Commit_Font]+.5;
                    CGFloat h = [ATools getHeightByWidth:Info_Width-16 title:content font:Commit_Font]+.5;
                    commitListH = commitListH + h;
                } else {
                    NSString *content = [NSString stringWithFormat:@"%@ @%@：%@",seObj.userName,seObj.otherName,seObj.commentContext];
//                    CGFloat h = [ATools getHeightByWidth:Info_Width-SecondView_LeftRight_SPace*2 title:content font:Commit_Font];
                    CGFloat h = [ATools getHeightByWidth:Info_Width title:content font:Commit_Font];
                    commitListH = commitListH + h;
                }
                
                if (i == (Default_Show_Count-1)) {
                    break;
                }
            }
            commitSecond = commitListH+5-5;
        }
        return commitSecond;
    }
    
    return 0;
}

- (void)loadUI {
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.commitLabel];
    [self addSubview:self.secondView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.praiseLabel];
    [self addSubview:self.lineLabel];
    [self setupMakeBodyViewSubViewsLayout];
}

- (void)setupMakeBodyViewSubViewsLayout {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(Top_Space_Y);
        make.left.mas_equalTo(self).mas_offset(Left_Space_X);
        make.width.mas_offset(Head_Image_WH);
        make.height.mas_offset(Head_Image_WH);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.mas_right).offset(Label_Space_X);
        make.top.mas_equalTo(_headImageView.mas_top).offset(0);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(NameLabel_H);
    }];
    [self.commitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left).offset(0);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(Label_Space_Y);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(NameLabel_H);
    }];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left).offset(0);
        make.top.mas_equalTo(_commitLabel.mas_bottom).offset(SecondView_Top_SPace_Y);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(0);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.width.mas_offset(DMScreenWidth/3);
        make.height.mas_offset(Bottom_Area_H/2);
    }];
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.width.mas_offset(Bottom_Area_H);
        make.height.mas_offset(32);
    }];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-0.5);
        make.height.mas_offset(0.5);
    }];

}

- (CommintSecondView *)secondView {
    if (_secondView == nil) {
        _secondView = [[CommintSecondView alloc] init];
        _secondView.backgroundColor = UIColorFromRGB(0xF2F2F2);
        [_secondView createCommitLabel:Info_Width];
    }
    return _secondView;
}
- (UIButton *)praiseLabel {
    if (_praiseLabel == nil) {
        _praiseLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseLabel setTitleColor:UIColorFromRGB(0x939393) forState:UIControlStateNormal];
        [_praiseLabel setImage:[UIImage imageNamed:@"praise_grey_icon"] forState:UIControlStateNormal];
        [_praiseLabel.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _praiseLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_praiseLabel addTarget:self action:@selector(clickPraise:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseLabel;
}
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromRGB(0xE96A79);
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}
- (UILabel *)commitLabel {
    if (_commitLabel == nil) {
        _commitLabel = [[UILabel alloc] init];
        _commitLabel.text = @"";
        _commitLabel.textAlignment = NSTextAlignmentLeft;
        _commitLabel.textColor = UIColorFromRGB(0x000000);
        _commitLabel.font = Commit_Font;
        //_commitLabel.backgroundColor = [UIColor whiteColor];
        _commitLabel.lineBreakMode  =NSLineBreakByClipping;
        _commitLabel.numberOfLines = 0;
    }
    return _commitLabel;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"";
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = UIColorFromRGB(0x939393);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = Head_Image_WH/2;
        _headImageView.layer.borderColor = UIColorFromRGB(0xE96A79).CGColor;//UIColorFromRGB(0xE96A79).CGColor;
        _headImageView.layer.borderWidth = 1;
    }
    return _headImageView;
}
- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = UIColorFromRGB(0xC3C3C3);
    }
    return _lineLabel;
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

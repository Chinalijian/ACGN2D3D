//
//  MsgTableViewCell.m
//  acgn
//
//  Created by Ares on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "MsgTableViewCell.h"
#import "CommintSecondView.h"

@interface MsgTableViewCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commitLabel;
@property (nonatomic, strong) CommintSecondView *secondView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *praiseLabel;

@property (nonatomic, strong) UIView *bottomView;

@end
@implementation MsgTableViewCell
#define SecondView_Left 10
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

- (void)cleanSubViewInfo {
    self.headImageView.image = nil;
    self.nameLabel.text = @"";
    self.commitLabel.text = @"";
    self.timeLabel.text = @"";
    [self.praiseLabel setTitle:@"" forState:UIControlStateNormal];
    [self.secondView cleanAllSubLabel];
}

- (void)configDynamicObj:(DynamicCommentListData *)obj {
    [self cleanSubViewInfo];
    if (!OBJ_IS_NIL(obj)) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:obj.avatar] placeholderImage:Default_Placeholder_Image];
        self.nameLabel.text = obj.otherName;
        self.commitLabel.text = obj.replyContext;
        self.timeLabel.text = obj.commentTime;
        [self.praiseLabel setTitle:obj.praiseNum forState:UIControlStateNormal];
        
        NSMutableArray *array = [NSMutableArray array];
        DynamicCommentSecondData *csData = [[DynamicCommentSecondData alloc] init];
        csData.userName = @"我";
        csData.otherName = obj.otherName;
        csData.commentContext = obj.commentContext;
        [array addObject:csData];
        obj.secondView = array;
        [self.secondView hiddenLabel:1];
        [self setSecondViewFirstInfo:csData];

        CGFloat commitH = [MsgTableViewCell getCommitContentMaxHeight:obj];
        CGFloat secondH = [MsgTableViewCell getSecondViewMaxHeight:obj];
        [self upDateCellLayout:commitH secondHeight:secondH];
        [self updateCommitContentFrame:commitH];
        [self updateSecondCommitViewFrame:secondH];
        [self layoutIfNeeded];
    }
}

- (void)setSecondViewFirstInfo:(DynamicCommentSecondData *)csData {
    [self.secondView setContentForFirstLabel:csData.userName otherName:csData.otherName content:csData.commentContext isUserNameNoColor:YES];
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
        make.left.mas_equalTo(_nameLabel.mas_left).offset(-SecondView_Left);
        make.top.mas_equalTo(_commitLabel.mas_bottom).offset(SecondView_Top_SPace_Y);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(secondH);
    }];
}

+ (CGFloat)getCellMaxHeightAndUpdate:(DynamicCommentListData *)dynamicObj {
    CGFloat commitH = [self getCommitContentMaxHeight:dynamicObj];
    CGFloat secondH = [self getSecondViewMaxHeight:dynamicObj];
    CGFloat heightRow = Content_List_Cell_H + commitH + secondH;
    return heightRow;
}

+ (CGFloat)getCommitContentMaxHeight:(DynamicCommentListData *)dynamicObj {
    if (OBJ_IS_NIL(dynamicObj)) {
        return 0;
    }
    return [ATools getHeightByWidth:Info_Width title:dynamicObj.replyContext font:Commit_Font];
}

+ (CGFloat)getSecondViewMaxHeight:(DynamicCommentListData *)dynamicObj {
    
    if (!OBJ_IS_NIL(dynamicObj)) {
        CGFloat commitSecond = 0;
        NSInteger count = dynamicObj.secondView.count;
        if (count > 0) {
            CGFloat commitListH = 0;//
            if (count > 3) {
                commitListH = 15*4 + 28;
            } else {
                commitListH = 15 * (count+1);
            }
            for (int i = 0; i < count; i++) {
                DynamicCommentSecondData *seObj = [dynamicObj.secondView objectAtIndex:i];
                NSString *content = [NSString stringWithFormat:@"%@@%@:%@",seObj.userName,seObj.otherName,seObj.commentContext];
                CGFloat h = [ATools getHeightByWidth:Info_Width-SecondView_LeftRight_SPace*2 title:content font:Commit_Font];
                commitListH = commitListH + h;
                if (i == 2) {
                    break;
                }
            }
            commitSecond = commitListH;
        }
        return commitSecond;
    }
    
    return 0;
}

- (void)loadUI {
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.commitLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.praiseLabel];
    [self addSubview:self.bottomView];
    [self addSubview:self.secondView];

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

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left).offset(0);
        make.top.mas_equalTo(_commitLabel.mas_bottom).offset(10);
        make.width.mas_offset(DMScreenWidth/3+30);
        make.height.mas_offset(Bottom_Area_H/2);
    }];
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(_commitLabel.mas_bottom).offset(5);
        make.width.mas_offset(Bottom_Area_H);
        make.height.mas_offset(22);
    }];

    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_left).offset(-SecondView_Left);
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(SecondView_Top_SPace_Y);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.secondView).offset(0);
        make.width.mas_offset(DMScreenWidth);
        make.bottom.mas_equalTo(self.secondView).mas_offset(0);
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

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    }
    return _bottomView;
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

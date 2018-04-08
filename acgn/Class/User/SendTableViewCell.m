//
//  SendTableViewCell.m
//  acgn
//
//  Created by Ares on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "SendTableViewCell.h"
#import "CommintSecondView.h"

@interface SendTableViewCell ()
@property (nonatomic, strong) CommintSecondView *secondView1;
@property (nonatomic, strong) CommintSecondView *secondView2;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *praiseLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *lineLabel;
@end

@implementation SendTableViewCell
#define Content_List_Cell_H 23//35 //cell的默认高度
#define Top_Space_Y     15    //距离上部的间距
#define Left_Space_X    16      //距离左边的间距
#define Bottom_Area_H   44      //距离底部间距
#define Label_Space_Y   15      //Label之间的上下边距
#define SecondView_Top_SPace_Y 30 //二级评论的上下间距
#define SecondView_LeftRight_SPace 10 //二级评论的左右间距
#define NameLabel_H     15
#define Info_Width DMScreenWidth-8*2 //评论内容label的宽度
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
    self.timeLabel.text = @"";
    [self.praiseLabel setTitle:@"" forState:UIControlStateNormal];
    [self.secondView1 cleanAllSubLabel];
    [self.secondView2 cleanAllSubLabel];
    self.secondView1.hidden = YES;
    self.secondView2.hidden = YES;
    self.bottomView.hidden = YES;
}

- (void)configDynamicObj:(DynamicCommentListData *)obj {
    [self cleanSubViewInfo];
    if (!OBJ_IS_NIL(obj)) {
        self.secondView1.hidden = NO;
        self.timeLabel.text = obj.commentTime;
        [self.praiseLabel setTitle:obj.praiseNum forState:UIControlStateNormal];

        DynamicCommentSecondData *csData = [[DynamicCommentSecondData alloc] init];
        csData.userName = STR_IS_NIL(obj.otherName)?@"": @"我";
        csData.otherName = STR_IS_NIL(obj.otherName)?@"": obj.otherName;
        csData.commentContext = obj.commentContext;


        [self.secondView1 hiddenLabel:1];
        [self setSecondViewFirstInfo:csData view:self.secondView1];
        CGFloat secondH1 = [SendTableViewCell getSecondViewMaxHeight:csData.userName otherName:csData.otherName context:csData.commentContext];
        CGFloat secondH2 = 0;
        if (!STR_IS_NIL(obj.replyContext)) {
            self.secondView2.hidden = NO;
            self.bottomView.hidden = NO;
            DynamicCommentSecondData *arData = [[DynamicCommentSecondData alloc] init];
            arData.userName = @"";
            arData.otherName = obj.otherName;
            arData.commentContext = obj.replyContext;
    
    
            [self.secondView2 hiddenLabel:1];
            [self setSecondViewFirstInfo:arData view:self.secondView2];
            secondH2 = [SendTableViewCell getSecondViewMaxHeight:arData.userName otherName:arData.otherName context:arData.commentContext];
            [self updateSecondCommitViewFrame:secondH2 view:self.secondView2];
        }
        [self upDateCellLayout:secondH1 secondHeight:secondH2];
        [self updateSecondCommitViewFrame:secondH1 view:self.secondView1];
        [self layoutIfNeeded];
    }
}

- (void)setSecondViewFirstInfo:(DynamicCommentSecondData *)csData view:(CommintSecondView *)viewSelf  {
    [viewSelf setContentForFirstLabel:csData.userName otherName:csData.otherName content:csData.commentContext isUserNameNoColor:YES];
}

- (void)upDateCellLayout:(CGFloat)secondH1 secondHeight:(CGFloat)secondH2 {
    CGFloat heightRow = Content_List_Cell_H + secondH1 + secondH2;
    self.frame = CGRectMake(0, 0, DMScreenWidth, heightRow);
}

- (void)updateSecondCommitViewFrame:(CGFloat)secondH view:(CommintSecondView *)viewSelf {
    [viewSelf mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(secondH+2);
    }];
}

+ (CGFloat)getCellMaxHeightAndUpdate:(DynamicCommentListData *)dynamicObj {
    CGFloat secondH1 = [self getSecondViewMaxHeight:@"我" otherName:dynamicObj.otherName context:dynamicObj.commentContext];
    CGFloat secondH2 = [self getSecondViewMaxHeight:@"" otherName:dynamicObj.otherName context:dynamicObj.replyContext];
    CGFloat heightRow = Content_List_Cell_H + secondH1 + secondH2;
    return heightRow;
}

+ (CGFloat)getCommitContentMaxHeight:(DynamicCommentListData *)dynamicObj {
    if (OBJ_IS_NIL(dynamicObj)) {
        return 0;
    }
    return [ATools getHeightByWidth:Info_Width title:dynamicObj.replyContext font:Commit_Font];
}

+ (CGFloat)getSecondViewMaxHeight:(NSString *)userName otherName:(NSString *)otherName context:(NSString *)context{
    if (!OBJ_IS_NIL(context)) {
        CGFloat commitListH = 15 * 2;
        NSString *content = context; //[NSString stringWithFormat:@"%@ @%@:%@",userName,otherName,context];
        CGFloat h = [ATools getHeightByWidth:Info_Width-SecondView_LeftRight_SPace*2 title:content font:Commit_Font];
        commitListH = commitListH + h;
        return commitListH;
    }
    return 0;
}

- (void)loadUI {
    [self addSubview:self.timeLabel];
    [self addSubview:self.praiseLabel];
    [self addSubview:self.bottomView];
    [self addSubview:self.secondView1];
    [self addSubview:self.secondView2];
    [self addSubview:self.lineLabel];
    [self setupMakeBodyViewSubViewsLayout];
    self.secondView1.backgroundColor = [UIColor clearColor];

}

- (void)setupMakeBodyViewSubViewsLayout {
    
    [self.secondView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(8);
        make.top.mas_equalTo(self).offset(0);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(Left_Space_X);
        make.top.mas_equalTo(_secondView1.mas_bottom).offset(-5);
        make.width.mas_offset(DMScreenWidth/3+30);
        make.height.mas_offset(Bottom_Area_H/2-10);
    }];
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-Left_Space_X);
        make.top.mas_equalTo(_secondView1.mas_bottom).offset(-10);
        make.width.mas_offset(Bottom_Area_H);
        make.height.mas_offset(22);
    }];
    
    [self.secondView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_secondView1.mas_left).offset(0);
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(10);
        make.width.mas_offset(Info_Width);
        make.height.mas_offset(0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.secondView2.mas_top).offset(0);
        make.width.mas_offset(DMScreenWidth);
        make.bottom.mas_equalTo(self.secondView2.mas_bottom).mas_offset(0);
    }];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-0.5);
        make.height.mas_offset(0.5);
    }];
}

- (CommintSecondView *)secondView1 {
    if (_secondView1 == nil) {
        _secondView1 = [[CommintSecondView alloc] init];
        _secondView1.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [_secondView1 createCommitLabel:Info_Width];
    }
    return _secondView1;
}

- (CommintSecondView *)secondView2 {
    if (_secondView2 == nil) {
        _secondView2 = [[CommintSecondView alloc] init];
        _secondView2.backgroundColor = UIColorFromRGB(0xF2F2F2);
        [_secondView2 createCommitLabel:Info_Width];
    }
    return _secondView2;
}
- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = UIColorFromRGB(0xC3C3C3);
    }
    return _lineLabel;
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

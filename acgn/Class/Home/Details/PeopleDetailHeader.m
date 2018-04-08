//
//  PeopleDetailHeader.m
//  acgn
//
//  Created by Ares on 2018/2/11.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "PeopleDetailHeader.h"
#import "ImageCom.h"
@interface PeopleDetailHeader()
@property (nonatomic, strong) RoleDetailsDataModel *dynamicObj;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIImageView *peopleImageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) UIButton *attButton;
@property (nonatomic, strong) UIButton *fansButton;

@property (nonatomic, strong) UIButton *image3DButton;

@property (nonatomic, assign) CGFloat introduceHeight;

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation PeopleDetailHeader

#define Space_Left_X 16

#define Name_Space_Y 40
#define Name_Label_H 18
#define Source_Label_Space_Y 14
#define Source_Label_H 14
#define Introduce_Label_Space_Y 12
//#define Introduce_Label_W 196
#define Introduce_Label_Width DMScreenWidth-Space_Left_X*2-PeopleImage_Width

#define PeopleImage_Height 186.5
#define PeopleImage_Width  138.5

#define Total_Default_Height 216.5

#define BottomView_H 34

#define BottomView_BottomToView 26

+ (CGFloat)getViewTotalHeight:(RoleDetailsDataModel *)obj {
    CGFloat totalHeight = 0;
    CGFloat indtroduceHeight = [PeopleDetailHeader getIntroduceMaxHeight:obj] + 10;
    totalHeight = indtroduceHeight + Name_Space_Y + Name_Label_H + Source_Label_Space_Y + Source_Label_H + Introduce_Label_Space_Y*2 + BottomView_H;
    if (totalHeight < Total_Default_Height) {
        totalHeight = Total_Default_Height;
    }
    return totalHeight+BottomView_BottomToView;
}

+ (CGFloat)getIntroduceMaxHeight:(RoleDetailsDataModel *)obj {
    if (OBJ_IS_NIL(obj)) {
        return 0;
    }
    return [ATools getHeightByWidth:Introduce_Label_Width title:obj.introduce font:Commit_Font withLineSpacing:5];
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(clickSelectPeopleImage:)]) {
        [self.delegate clickSelectPeopleImage:self.dynamicObj.roleId];
    }
}

- (void)clickAttBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickClickAttBtn:)]) {
        [self.delegate clickClickAttBtn:self.dynamicObj];
    }
}

- (void)clickModeShow:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickGotoModeShow:)]) {
        [self.delegate clickGotoModeShow:sender];
    }
}

- (void)configInfo:(RoleDetailsDataModel *)obj {
    self.introduceHeight = [PeopleDetailHeader getIntroduceMaxHeight:obj]+10;
    [self loadUI];
    self.dynamicObj = obj;
    self.nameLabel.text = self.dynamicObj.userName;
    self.sourceLabel.text = self.dynamicObj.source;
    self.introduceLabel.attributedText = [ATools attributedStringFromStingWithFont:Commit_Font withLineSpacing:5 text:self.dynamicObj.introduce isEllipsis:NO];
    //self.introduceLabel.text = self.dynamicObj.introduce;
    //[ATools changeLineSpaceForLabel:self.introduceLabel WithSpace:5];
//    NSString * imageUrl = [self.dynamicObj.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [self.peopleImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    [ATools loadImageUrlForImageView:self.peopleImageView imageUrl:self.dynamicObj.imageUrl];
    if (self.dynamicObj.hasFollow.intValue >= 1) {
        [self.attButton setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [self.attButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝：%@", self.dynamicObj.fansNum] forState:UIControlStateNormal];
}

- (void)updateAttBtn:(BOOL)isAtt {
    if (isAtt) { //关注
        [self.attButton setTitle:@"已关注" forState:UIControlStateNormal];
        self.dynamicObj.hasFollow = @"1";
    } else {
        [self.attButton setTitle:@"关注" forState:UIControlStateNormal];
        self.dynamicObj.hasFollow = @"-1";
    }
}

- (id)initWithframe:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self loadUI];
        self.dynamicObj = [[RoleDetailsDataModel alloc] init];
    }
    return self;
}

- (void)loadUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.sourceLabel];
    [self addSubview:self.introduceLabel];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.alphaView];
    [self.bottomView addSubview:self.attButton];
    [self.bottomView addSubview:self.fansButton];
    [self addSubview:self.peopleImageView];
    [self addSubview:self.image3DButton];

    [self setupTopContentLayout];
}

- (void)setupTopContentLayout {
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-BottomView_BottomToView);
    }];
    CGFloat YY = Name_Space_Y+[ATools getNavViewFrameHeightForIPhone];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(YY);
        make.height.mas_offset(Name_Label_H);
        make.left.mas_equalTo(self).mas_offset(Space_Left_X);
        make.width.mas_offset(Introduce_Label_Width);
    }];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(Source_Label_Space_Y);
        make.height.mas_offset(Source_Label_H);
        make.left.mas_equalTo(self.nameLabel).mas_offset(0);
        make.right.mas_equalTo(self.nameLabel).mas_offset(0);
    }];
    [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sourceLabel.mas_bottom).mas_offset(Introduce_Label_Space_Y);
        make.height.mas_offset(self.introduceHeight);
        make.left.mas_equalTo(self.nameLabel).mas_offset(0);
        make.right.mas_equalTo(self.nameLabel).mas_offset(0);
    }];
    
    [self setupMakeBottomSubViewsLayout];
    
    [_peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-BottomView_BottomToView);
        make.right.mas_equalTo(self).mas_offset(-5);
        make.height.mas_offset(PeopleImage_Height);
        make.width.mas_offset(PeopleImage_Width);
    }];
    
    [_image3DButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_peopleImageView.mas_bottom).mas_offset(-5);
        make.right.mas_equalTo(_bottomView.mas_right).mas_offset(-10);
        make.height.mas_offset(22);
        make.width.mas_offset(82);
    }];
    
}

- (void)setupMakeBottomSubViewsLayout {
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-BottomView_BottomToView);
        make.left.mas_equalTo(self).mas_offset(0);
        make.right.mas_equalTo(self).mas_offset(0);
        make.height.mas_offset(BottomView_H);
    }];
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView).mas_offset(0);
        make.top.mas_equalTo(self.bottomView).mas_offset(0);
        make.left.mas_equalTo(self.bottomView).mas_offset(0);
        make.right.mas_equalTo(self.bottomView).mas_offset(0);
    }];
    [_attButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).mas_offset(-5);
        make.top.mas_equalTo(self.bottomView).mas_offset(5);
        make.left.mas_equalTo(self.bottomView).mas_offset(Space_Left_X);
        make.width.mas_offset(44);
    }];
    [_fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.attButton).mas_offset(0);
        make.top.mas_equalTo(self.attButton).mas_offset(0);
        make.left.mas_equalTo(self.attButton.mas_right).mas_offset(Space_Left_X);
        make.width.mas_offset(90);
    }];
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"details_header_bg_icon"];
    }
    return _bgImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}
- (UILabel *)sourceLabel {
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.text = @"";
        _sourceLabel.textAlignment = NSTextAlignmentLeft;
        _sourceLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _sourceLabel.font = [UIFont systemFontOfSize:12];
    }
    return _sourceLabel;
}
- (UILabel *)introduceLabel {
    if (_introduceLabel == nil) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.text = @"";
        _introduceLabel.textAlignment = NSTextAlignmentLeft;
        _introduceLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _introduceLabel.font = [UIFont systemFontOfSize:13];
        _introduceLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _introduceLabel.numberOfLines = 0;
    }
    return _introduceLabel;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}
- (UIView *)alphaView {
    if (_alphaView == nil) {
        _alphaView = [[UIView alloc] init];
        _alphaView.backgroundColor = [UIColor whiteColor];
        _alphaView.alpha = .1;
    }
    return _alphaView;
}
- (UIButton *)attButton {
    if (_attButton == nil) {
        _attButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_attButton setBackgroundColor: UIColorFromRGB(0xE96A79)];
        [_attButton setTitle:@"关注" forState:UIControlStateNormal];
        _attButton.layer.cornerRadius = 8;
        [_attButton addTarget:self action:@selector(clickAttBtn:) forControlEvents:UIControlEventTouchUpInside];
//        _attButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return _attButton;
}
- (UIButton *)fansButton {
    if (_fansButton == nil) {
        _fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fansButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fansButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_fansButton setImage:[UIImage imageNamed:@"fans_image_icon"] forState:UIControlStateNormal];
        [_fansButton setTitle:@"   粉丝：" forState:UIControlStateNormal];
        _fansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _fansButton;
}


- (UIImageView *)peopleImageView {
    if (_peopleImageView == nil) {
        _peopleImageView = [[UIImageView alloc] init];
        _peopleImageView.clipsToBounds = YES;
        _peopleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _peopleImageView.backgroundColor = [UIColor clearColor];
        _peopleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired =1;
        [_peopleImageView addGestureRecognizer:tap];
    }
    return _peopleImageView;
}

- (UIButton *)image3DButton {
    if (_image3DButton == nil) {
        _image3DButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_image3DButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_image3DButton setTitle:@"立体形象" forState:UIControlStateNormal];
        [_image3DButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_image3DButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _image3DButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _image3DButton.layer.cornerRadius = 8;
        _image3DButton.alpha = .8;
        [_image3DButton setBackgroundColor: UIColorFromRGB(0xE96A79)];
        [_image3DButton addTarget:self action:@selector(clickModeShow:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _image3DButton;
}


@end

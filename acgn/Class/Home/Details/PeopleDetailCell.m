//
//  PeopleDetailCell.m
//  acgn
//
//  Created by Ares on 2018/2/11.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "PeopleDetailCell.h"
#import "ImageCom.h"

#define Space_Bottom_Cell 32
#define Button_View_ 25
#define Time_Width 70
#define TypeButton_W 30.5
#define Space_Right_Cell 24
#define Space_Left_View 13
#define Space_Content_ 10
#define Video_Height 101
#define Content_With (DMScreenWidth-Space_Right_Cell-Space_Left_View-TypeButton_W-Space_Left_View-Time_Width)
#define Pic_Height (Content_With)*(0.64)+5
#define Small_Image_W_H 63
#define Small_Image_Space 4
@interface PeopleDetailCell () <ImageComDelegate>

@property (nonatomic, strong) UILabel *bigTimeLabel;
@property (nonatomic, strong) UILabel *smallTimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *seeNumButton;
@property (nonatomic, strong) UIButton *commitNumButton;
@property (nonatomic, strong) UIButton *praiseNumButton;

@property (nonatomic, strong) ImageCom *imageCom;
@property (nonatomic, strong) RoleDetailsPostData *roleData;
@end

@implementation PeopleDetailCell
+ (CGFloat)getPeopleDetailCellHeight:(RoleDetailsPostData *)obj {
    CGFloat contentHeight = [PeopleDetailCell getContentMaxHeight:obj]+10;
    CGFloat picHeight = 0;
    if (obj.postType.integerValue == Info_Type_GIf_Pic) {
        //图片
        picHeight = [PeopleDetailCell getImageMaxHeight:obj];
        if (picHeight>0) {
            picHeight = picHeight + Space_Content_;
        }
        
    } else if (obj.postType.integerValue == Info_Type_Video || obj.postType.integerValue == Info_Type_Url_Video) {
        //视频
        picHeight = Video_Height + 50+30;
    }
    CGFloat totalHeight = contentHeight + picHeight + Button_View_ + Space_Bottom_Cell + Space_Content_;
    return totalHeight;
}
+ (CGFloat)getContentMaxHeight:(RoleDetailsPostData *)obj {
    if (OBJ_IS_NIL(obj)) {
        return 0;
    }
    return [ATools getHeightByWidth:Content_With title:obj.postContext font:Commit_Font];
}
+ (CGFloat)getImageMaxHeight:(RoleDetailsPostData *)obj {
    if (obj.postUrls.count > 0) {
        if (obj.postUrls.count == 1) {
            return Pic_Height;
        } else {
            NSInteger rowCount = obj.postUrls.count/3;
            if (obj.postUrls.count%3 == 0) {
                return Small_Image_W_H*rowCount+Small_Image_Space*(rowCount+1);
            } else {
                return Small_Image_W_H*(rowCount+1)+Small_Image_Space*(rowCount+2);
            }
        }
    }
    return 0;
}

- (void)configInfo:(RoleDetailsPostData *)obj {
    [self cleanObjSubView];
    if (!OBJ_IS_NIL(obj)) {
        self.roleData = obj;
        NSArray *array = [obj.postTime componentsSeparatedByString:@" "];
        if (array.count == 1) {
            self.bigTimeLabel.text = [array firstObject];
            self.smallTimeLabel.text = @"";
        } else if (array.count == 2) {
            self.bigTimeLabel.text = [array firstObject];
            self.smallTimeLabel.text = [array lastObject];
        } else {
            self.bigTimeLabel.text = @"";
            self.smallTimeLabel.text = @"";
        }
        
        self.contentLabel.text = obj.postContext;
        
        switch (obj.postType.integerValue) {
            case Info_Type_Text:
                self.typeImageView.image = [UIImage imageNamed:@"Text_Image_Icon"];
                break;
//            case Info_Type_Picture:
//                self.typeImageView.image = [UIImage imageNamed:@"Picture_Image_Icon"];
//                break;
            case Info_Type_GIf_Pic:
                self.typeImageView.image = [UIImage imageNamed:@"Picture_Image_Icon"];
                break;
            case Info_Type_Video:
                self.typeImageView.image = [UIImage imageNamed:@"Video_Image_Icon"];
                break;
            case Info_Type_Url_Video:
                self.typeImageView.image = [UIImage imageNamed:@"Video_Image_Icon"];
                break;
            default:
                break;
        }
        
        CGFloat contentH = [PeopleDetailCell getContentMaxHeight:obj];
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(contentH);
        }];
        
        if (obj.postType.integerValue != 0) {
            self.imageCom.hidden = NO;
            CGFloat imageH = [PeopleDetailCell getImageMaxHeight:obj];
            [_imageCom mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(imageH);
            }];
            
            [self.imageCom configImageCom:obj.postUrls height:imageH type:obj.postType.integerValue thumbnailUrl:obj.thumbnailUrl];
        }
        [self.seeNumButton setTitle:obj.seeNum forState:UIControlStateNormal];
        [self.commitNumButton setTitle:obj.commentNum forState:UIControlStateNormal];
        [self.praiseNumButton setTitle:obj.fabulousNum forState:UIControlStateNormal];
        if (obj.localPraise) {
            [_praiseNumButton setImage:[UIImage imageNamed:@"praise_yellow_icon"] forState:UIControlStateNormal];
        } else {
            [_praiseNumButton setImage:[UIImage imageNamed:@"praise_grey_icon"] forState:UIControlStateNormal];
        }
        [self layoutSubviews];
    }
    
}


- (void)clickPraise:(id)sender {
    if ([self.delegate respondsToSelector:@selector(userClickFabulousPraise:)]) {
        [self.delegate userClickFabulousPraise:self.roleData];
    }
}

- (void)clickVideoImagePlay:(Info_Type)type videoUrl:(NSString *)videoUrl {
    if ([self.delegate respondsToSelector:@selector(userClickVideo:videoUrl:)]) {
        [self.delegate userClickVideo:type videoUrl:videoUrl];
    }
}

- (void)cleanObjSubView {
    self.bigTimeLabel.text = @"";
    self.smallTimeLabel.text = @"";
    self.contentLabel.text = @"";
    self.imageCom.hidden = YES;
    [self.seeNumButton setTitle:@"0" forState:UIControlStateNormal];
    [self.commitNumButton setTitle:@"0" forState:UIControlStateNormal];
    [self.praiseNumButton setTitle:@"0" forState:UIControlStateNormal];
    
}

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

- (void)loadUI {
    [self addSubview:self.bigTimeLabel];
    [self addSubview:self.smallTimeLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.imageCom];
    [self addSubview:self.typeImageView];
    [self addSubview:self.lineLabel];
    [self addSubview:self.buttonView];
    [self.buttonView addSubview:self.seeNumButton];
    [self.buttonView addSubview:self.commitNumButton];
    [self.buttonView addSubview:self.praiseNumButton];
    
    [self setupMakeBodyViewSubViewsLayout];
}

- (void)setupMakeBodyViewSubViewsLayout {
    [self.bigTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(0);
        make.width.mas_offset(Time_Width);
        make.height.mas_offset(28);
    }];
    [self.smallTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bigTimeLabel.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self).mas_offset(0);
        make.width.mas_offset(Time_Width);
        make.height.mas_offset(12);
    }];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(0);
        make.left.mas_equalTo(self.bigTimeLabel.mas_right).mas_offset(13);
        make.width.mas_offset(TypeButton_W);
        make.height.mas_offset(TypeButton_W);
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(0);
        make.centerX.mas_equalTo(self.typeImageView);
        make.bottom.mas_equalTo(self).mas_offset(0);
        make.width.mas_offset(0.5);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeImageView.mas_top).mas_offset(10);
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(Space_Left_View);
        make.height.mas_offset(0);
        make.width.mas_offset(Content_With);
    }];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-Space_Bottom_Cell);
        make.left.mas_equalTo(self.contentLabel.mas_left).mas_offset(0);
        make.height.mas_offset(Button_View_);
        make.width.mas_offset(Content_With);
    }];
    
    [self.imageCom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(Space_Content_);
        make.left.mas_equalTo(self.contentLabel.mas_left).mas_offset(0);
        //make.height.mas_offset(0);
        make.bottom.mas_equalTo(self.buttonView.mas_top).mas_equalTo(10);
        make.width.mas_offset(Content_With);
    }];
    
    [self.seeNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView).mas_offset(0);
        make.left.mas_equalTo(self.buttonView).mas_offset(0);
        make.top.mas_equalTo(self.buttonView).mas_offset(0);
        make.width.mas_offset(Content_With/3);
    }];
    [self.commitNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView).mas_offset(0);
        make.centerX.mas_equalTo(self.buttonView);
        make.top.mas_equalTo(self.buttonView).mas_offset(0);
        make.width.mas_offset(Content_With/3);
    }];
    [self.praiseNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView).mas_offset(0);
        make.right.mas_equalTo(self.buttonView).mas_offset(0);
        make.top.mas_equalTo(self.buttonView).mas_offset(0);
        make.width.mas_offset(Content_With/3);
    }];
    
}

- (ImageCom *)imageCom {
    if (_imageCom == nil) {
        _imageCom = [[ImageCom alloc] initWithBigImage:Content_With-10 bigImageHeight:Pic_Height-10 smallImageWidth:Small_Image_W_H samllImageHeight:Small_Image_W_H smallSpace:Small_Image_Space frameW:Content_With frameH:0];
        _imageCom.delegate = self;
        _imageCom.backgroundColor = [UIColor clearColor];
    }
    return _imageCom;
}

- (UILabel *)bigTimeLabel {
    if (_bigTimeLabel == nil) {
        _bigTimeLabel = [[UILabel alloc] init];
        _bigTimeLabel.text = @"";
        _bigTimeLabel.textAlignment = NSTextAlignmentRight;
        _bigTimeLabel.textColor = UIColorFromRGB(0x000000);
        _bigTimeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _bigTimeLabel;
}
- (UILabel *)smallTimeLabel {
    if (_smallTimeLabel == nil) {
        _smallTimeLabel = [[UILabel alloc] init];
        _smallTimeLabel.text = @"";
        _smallTimeLabel.textAlignment = NSTextAlignmentRight;
        _smallTimeLabel.textColor = UIColorFromRGB(0x000000);
        _smallTimeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _smallTimeLabel;
}
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"";
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = UIColorFromRGB(0x000000);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UILabel *)lineLabel {
    if (_lineLabel == nil) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = UIColorFromRGB(0x696969);
    }
    return _lineLabel;
}

- (UIImageView *)typeImageView {
    if (_typeImageView == nil) {
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.clipsToBounds = YES;
        _typeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _typeImageView.backgroundColor = [UIColor clearColor];
        _typeImageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        tap.numberOfTapsRequired =1;
//        tap.numberOfTouchesRequired =1;
//        [_typeImageView addGestureRecognizer:tap];
    }
    return _typeImageView;
}

- (UIView *)buttonView {
    if (_buttonView == nil) {
        _buttonView = [[UIView alloc] init];
        //_buttonView.backgroundColor = [UIColor yellowColor];
    }
    return _buttonView;
}

- (UIButton *)seeNumButton {
    if (_seeNumButton == nil) {
        _seeNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeNumButton setTitleColor:UIColorFromRGB(0x696969) forState:UIControlStateNormal];
        [_seeNumButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_seeNumButton setImage:[UIImage imageNamed:@"look_img_grey"] forState:UIControlStateNormal];
        [_seeNumButton setTitle:@"0" forState:UIControlStateNormal];
        _seeNumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _seeNumButton;
}
- (UIButton *)commitNumButton {
    if (_commitNumButton == nil) {
        _commitNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitNumButton setTitleColor:UIColorFromRGB(0x696969) forState:UIControlStateNormal];
        [_commitNumButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_commitNumButton setImage:[UIImage imageNamed:@"comment_img_grey"] forState:UIControlStateNormal];
        [_commitNumButton setTitle:@"0" forState:UIControlStateNormal];
        _commitNumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _commitNumButton;
}
- (UIButton *)praiseNumButton {
    if (_praiseNumButton == nil) {
        _praiseNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseNumButton setTitleColor:UIColorFromRGB(0x696969) forState:UIControlStateNormal];
        [_praiseNumButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_praiseNumButton setImage:[UIImage imageNamed:@"praise_grey_icon"] forState:UIControlStateNormal];
        [_praiseNumButton setTitle:@"0" forState:UIControlStateNormal];
        _praiseNumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_praiseNumButton addTarget:self action:@selector(clickPraise:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseNumButton;
}


@end

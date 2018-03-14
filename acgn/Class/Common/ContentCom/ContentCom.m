//
//  ContentCom.m
//  acgn
//
//  Created by lijian on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ContentCom.h"

@interface ContentCom()

@property (nonatomic, assign) ContentCom_Type ccType;

@property (nonatomic, strong) DynamicListData *dynamicObj;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) ImageCom *imageComView;
@property (nonatomic, strong) UIImageView *peopleImageView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) UIButton *attButton;
@property (nonatomic, strong) UIButton *comButton;
@property (nonatomic, strong) UIButton *praButton;
@property (nonatomic, strong) UIButton *favButton;

@property (nonatomic, strong) UIButton *attBtn;

@end

@implementation ContentCom
#define Space_Left_X 16
#define Space_Y 16
#define Label_Space_Y 8.5

#define Name_Label_H 18
#define Time_Label_H 14
#define From_Label_H 14

#define PeopleImage_Height 186.5
#define PeopleImage_Width  138.5

#define Content_Label_Space_Y 16
#define Content_Label_H 72
#define Content_Label_Widht DMScreenWidth-Space_Left_X*2-PeopleImage_Width-10

#define Image_Height (Content_Label_Widht)*(0.64)+5
#define Image_Width (Content_Label_Widht)-10
#define Image_Space 8

#define Small_Image_W_H 63
#define Small_Image_Space 4

#define Temp_Nav_H [ATools getNavViewFrameHeightForIPhone]

#define BottomView_H 34

+ (CGFloat)getContentCommonCellHeight:(DynamicListData *)obj contentType:(ContentCom_Type)type {
    NSLog(@"dd = %f",(Content_Label_Widht)*(0.64)+10);
    CGFloat totalHeight = 0;
    CGFloat tempNavHeight = Temp_Nav_H;
    CGFloat imageH = 0;
    if (obj.postType.integerValue != Info_Type_Text) {
        imageH = [ContentCom getImageMaxHeight:obj];
        if ((obj.postType.integerValue == Info_Type_Url_Video || obj.postType.integerValue == Info_Type_Video)) {
            if (STR_IS_NIL(obj.thumbnailUrl) && obj.postUrls.count == 0) {
                imageH = 0;
            } else {
                imageH = Image_Height;
            }
            
        }
    }
    CGFloat contentH = [ContentCom getContentMaxHeight:obj];
    CGFloat contentTotalH = Content_Label_Space_Y;
    if (contentH > 0) {
        if (type != ContentCom_Type_All) {
            contentH = (contentH > Content_Label_H ? Content_Label_H:contentH+10);
        }
        contentTotalH = contentTotalH + contentH;
    }
    CGFloat imageTotalH = Image_Space;
    if (imageH > 0) {
        imageTotalH = imageH + Image_Space*2;
    }
    totalHeight =  contentTotalH + imageTotalH + Name_Label_H+Time_Label_H+From_Label_H + Space_Y + Label_Space_Y*2 + BottomView_H;
    
    if (totalHeight <= PeopleImage_Height) {
        totalHeight = totalHeight + (PeopleImage_Height-totalHeight) + 20;
    }
    if (type == ContentCom_Type_All) {
        totalHeight = totalHeight + tempNavHeight;
    }
    return totalHeight;
}

+ (CGFloat)getImageMaxHeight:(DynamicListData *)obj {
    if (obj.postUrls.count > 0) {
        if (obj.postUrls.count == 1) {
            return Image_Height;
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

+ (CGFloat)getContentMaxHeight:(DynamicListData *)obj {
    if (OBJ_IS_NIL(obj)) {
        return 0;
    }
    return [ATools getHeightByWidth:Content_Label_Widht title:obj.postContext font:Commit_Font withLineSpacing:5];
}

- (void)clickPraise:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickPraiseFabulous:view:)]) {
        [self.delegate clickPraiseFabulous:self.dynamicObj view:self];
    }
}

- (void)clickFavBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickFavForUser:view:)]) {
        [self.delegate clickFavForUser:self.dynamicObj view:self];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(clickSelectPeopleImage:)]) {
        [self.delegate clickSelectPeopleImage:self.dynamicObj.roleId];
    }
}
- (void)tapActionRootView:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(clickSelectSectionViewForGoToDetail:)]) {
        [self.delegate clickSelectSectionViewForGoToDetail:self.dynamicObj];
    }
}

- (void)clickVideoImagePlay:(Info_Type)type videoUrl:(NSString *)videoUrl; {
    if ([self.delegate respondsToSelector:@selector(clickVideoPlay:videoUrl:)]) {
        [self.delegate clickVideoPlay:type videoUrl:videoUrl];
    }
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.ccType = ContentCom_Type_LineNumber;
        [self loadUI];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionRootView:)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired =1;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame contentComType:(ContentCom_Type)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.ccType = type;
        [self loadUI];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionRootView:)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired =1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)configInfo:(DynamicListData *)obj {
    self.dynamicObj = obj;
    self.nameLabel.text = obj.userName;
    self.timeLabel.text = obj.postTime;
    self.fromLabel.text = [NSString stringWithFormat:@"发自：%@", obj.postSource];
    CGFloat contentH = [ContentCom getContentMaxHeight:obj];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    BOOL isEllipsis = YES;
    if (self.ccType != ContentCom_Type_All) {
        if (contentH < Content_Label_H) {
            self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            isEllipsis = NO;
        }
    }
    self.contentLabel.attributedText = [ATools attributedStringFromStingWithFont:Commit_Font withLineSpacing:5 text:obj.postContext isEllipsis:isEllipsis];
//    self.contentLabel.text = obj.postContext;
//    [ATools changeLineSpaceForLabel:self.contentLabel WithSpace:5];
    NSString * imageUrl = [obj.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.peopleImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    [self.attButton setTitle:obj.seeNum forState:UIControlStateNormal];
    [self.comButton setTitle:obj.commentNum forState:UIControlStateNormal];
    [self.praButton setTitle:obj.fabulousNum forState:UIControlStateNormal];
    if (obj.localPraise) {
        [self.praButton setImage:[UIImage imageNamed:@"praise_yellow_icon"] forState:UIControlStateNormal];
    } else {
        [self.praButton setImage:[UIImage imageNamed:@"praise_white_icon"] forState:UIControlStateNormal];
    }
    
    if (obj.hasFollow.intValue > 0) {
        _attBtn.hidden = YES;
    } else {
        _attBtn.hidden = NO;
    }
    
    if (obj.favPage) {
        
        [_favButton setImage:nil forState:UIControlStateNormal];
        [_favButton setBackgroundColor:UIColorFromRGB(0xE96A79)];
        [_favButton setTitle:@"删除" forState:UIControlStateNormal];
        [_favButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _favButton.layer.cornerRadius = 9;
        [_favButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _favButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        if (obj.hasCollection.intValue == 0) {
            [_favButton setImage:[UIImage imageNamed:@"collection_white"] forState:UIControlStateNormal];
        } else {
            [_favButton setImage:[UIImage imageNamed:@"collection_yellow"] forState:UIControlStateNormal];
        }
    }
    
    CGFloat nameW = [ATools getHeightByHeight:Name_Label_H title:obj.userName font:[UIFont boldSystemFontOfSize:18]];
    [_attBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Space_Left_X+nameW+10);
    }];
    
    if (self.ccType != ContentCom_Type_All) {
        if (contentH < Content_Label_H) {
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(contentH+10);
            }];
        }
    } else {
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(contentH+10);
        }];
    }
    CGFloat imageH = 0;
    if (obj.postType.integerValue != Info_Type_Text) {
        imageH = [ContentCom getImageMaxHeight:obj];
        if ((obj.postType.integerValue == Info_Type_Url_Video || obj.postType.integerValue == Info_Type_Video)) {
            if (STR_IS_NIL(obj.thumbnailUrl) && obj.postUrls.count == 0) {
                imageH = 0;
            } else {
                imageH = Image_Height;
            }
            
        }
        [_imageComView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(Image_Space);
            make.height.mas_offset(imageH);
        }];
        if (obj.postType.integerValue == Info_Type_Url_Video || obj.postType.integerValue == Info_Type_Video) {
            self.imageComView.viedoTime = obj.videoTime;
        }
        [self.imageComView configImageCom:obj.postUrls height:imageH type:obj.postType.integerValue thumbnailUrl:obj.thumbnailUrl];
    }
   
    //[self layoutSubviews];
}

- (void)clickAttBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickAttForUser:view:)]) {
        [self.delegate clickAttForUser:self.dynamicObj view:self];
    }
}

- (void)updateFabulous {
    [self.praButton setTitle:self.dynamicObj.fabulousNum forState:UIControlStateNormal];
    if (self.dynamicObj.localPraise) {
        [self.praButton setImage:[UIImage imageNamed:@"praise_yellow_icon"] forState:UIControlStateNormal];
    } else {
        [self.praButton setImage:[UIImage imageNamed:@"praise_white_icon"] forState:UIControlStateNormal];
    }
}

- (void)updateCollectionView {
    
    if (self.dynamicObj.hasCollection.intValue == 0) {
        [_favButton setImage:[UIImage imageNamed:@"collection_white"] forState:UIControlStateNormal];
    } else {
        [_favButton setImage:[UIImage imageNamed:@"collection_yellow"] forState:UIControlStateNormal];
    }
}

- (void)updateAttentView {
    if (self.dynamicObj.hasFollow.intValue > 0) {
        //[_attBtn setTitle:@"已关注" forState:UIControlStateNormal];
        _attBtn.hidden = YES;
    } else {
        _attBtn.hidden = NO;
        [_attBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
}

- (void)loadUI {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.attBtn];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.fromLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentView addSubview:self.imageComView];
    
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.alphaView];
    [self.bottomView addSubview:self.attButton];
    [self.bottomView addSubview:self.comButton];
    [self.bottomView addSubview:self.praButton];
    
    [self.contentView addSubview:self.peopleImageView];
    
    [self.contentView addSubview:self.favButton];
    
    [self setupTopContentLayout];
}

- (void)setupTopContentLayout {
    CGFloat YY = Space_Y;
    if (self.ccType == ContentCom_Type_All) {
        YY = YY + Temp_Nav_H;
    }
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(YY);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_offset(Name_Label_H);
        make.left.mas_equalTo(self.contentView).mas_offset(Space_Left_X);
        make.right.mas_equalTo(self.contentView).mas_offset(-Space_Left_X);
    }];
    [_attBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).mas_offset(0);
        make.top.mas_equalTo(_nameLabel.mas_top).mas_offset(-2);
        make.width.mas_offset(42);
        make.height.mas_offset(22);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(Label_Space_Y);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_offset(Time_Label_H);
        make.left.mas_equalTo(self.nameLabel).mas_offset(0);
        make.right.mas_equalTo(self.nameLabel).mas_offset(0);
    }];
    [_fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(Label_Space_Y-4);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_offset(From_Label_H);
        make.left.mas_equalTo(self.timeLabel).mas_offset(0);
        make.right.mas_equalTo(self.timeLabel).mas_offset(0);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fromLabel.mas_bottom).mas_offset(Content_Label_Space_Y);
        make.left.mas_equalTo(self.fromLabel).mas_offset(0);
        make.width.mas_offset(Content_Label_Widht);
        make.height.mas_offset(Content_Label_H);
    }];
    
    [_imageComView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLabel.mas_bottom).mas_offset(Image_Space);
        make.left.mas_equalTo(_contentLabel.mas_left).mas_offset(0);
        make.width.mas_offset(Image_Width);
        make.height.mas_offset(0);
    }];
    
    [self setupMakeBottomSubViewsLayout];
    
    [_peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.contentView).mas_offset(-20);
        make.height.mas_offset(PeopleImage_Height);
        make.width.mas_offset(PeopleImage_Width);
    }];
    
    [_favButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).mas_offset(-6);
//        make.top.mas_equalTo(self.bottomView.mas_top).mas_offset(0);
        make.right.mas_equalTo(self.alphaView.mas_right).mas_offset(-5);
        make.width.mas_offset(42);
        make.height.mas_offset(22);
    }];
    
}

- (void)setupMakeBottomSubViewsLayout {
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.contentView).mas_offset(0);
        make.right.mas_equalTo(self.contentView).mas_offset(0);
        make.height.mas_offset(BottomView_H);
    }];
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView).mas_offset(0);
        make.top.mas_equalTo(self.bottomView).mas_offset(0);
        make.left.mas_equalTo(self.bottomView).mas_offset(0);
        make.right.mas_equalTo(self.bottomView).mas_offset(0);
    }];
    CGFloat width = (DMScreenWidth-PeopleImage_Width-Space_Left_X*2)/3;
    [_attButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView).mas_offset(0);
        make.top.mas_equalTo(self.bottomView).mas_offset(0);
        make.left.mas_equalTo(self.bottomView).mas_offset(Space_Left_X);
        make.width.mas_offset(width);
    }];
    [_comButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.attButton).mas_offset(0);
        make.top.mas_equalTo(self.attButton).mas_offset(0);
        make.left.mas_equalTo(self.attButton.mas_right).mas_offset(0);
        make.width.mas_offset(width);
    }];
    [_praButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.comButton).mas_offset(0);
        make.top.mas_equalTo(self.comButton).mas_offset(0);
        make.left.mas_equalTo(self.comButton.mas_right).mas_offset(0);
        make.width.mas_offset(width);
    }];
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColorFromRGB(0xE98A79);
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"";
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = UIColorFromRGB(0x000000);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"";
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = UIColorFromRGB(0x000000);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 3;
        if (self.ccType == ContentCom_Type_All) {
            _contentLabel.numberOfLines = 0;
        }
         [_contentLabel sizeToFit];
        //_contentLabel.backgroundColor = [UIColor redColor];
    }
    return _contentLabel;
}
- (UILabel *)fromLabel {
    if (_fromLabel == nil) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.text = @"";
        _fromLabel.textAlignment = NSTextAlignmentLeft;
        _fromLabel.textColor = UIColorFromRGB(0x000000);
        _fromLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fromLabel;
}

- (ImageCom *)imageComView {
    if (_imageComView == nil) {
        _imageComView = [[ImageCom alloc] initWithBigImage:Image_Width bigImageHeight:Image_Height-10 smallImageWidth:Small_Image_W_H samllImageHeight:Small_Image_W_H smallSpace:Small_Image_Space frameW:Content_Label_Widht frameH:0];
        _imageComView.delegate = self;
        _imageComView.backgroundColor = [UIColor clearColor];
    }
    return _imageComView;
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
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = .2;
    }
    return _alphaView;
}
- (UIButton *)attButton {
    if (_attButton == nil) {
        _attButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_attButton setImage:[UIImage imageNamed:@"look_img_white"] forState:UIControlStateNormal];
        _attButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _attButton.userInteractionEnabled = NO;
    }
    return _attButton;
}
- (UIButton *)comButton {
    if (_comButton == nil) {
        _comButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_comButton setImage:[UIImage imageNamed:@"comment_img_white"] forState:UIControlStateNormal];
        _comButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _comButton.userInteractionEnabled = NO;
    }
    return _comButton;
}
- (UIButton *)praButton {
    if (_praButton == nil) {
        _praButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_praButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_praButton setImage:[UIImage imageNamed:@"praise_white_icon"] forState:UIControlStateNormal];
        _praButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_praButton addTarget:self action:@selector(clickPraise:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praButton;
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

- (UIButton *)favButton {
    if (_favButton == nil) {
        _favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favButton setImage:[UIImage imageNamed:@"collection_white"] forState:UIControlStateNormal];
        _favButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_favButton addTarget:self action:@selector(clickFavBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favButton;
}

- (UIButton *)attBtn {
    if (_attBtn == nil) {
        _attBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_attBtn setBackgroundColor: UIColorFromRGB(0xE96A79)];
        [_attBtn setTitle:@"关注" forState:UIControlStateNormal];
        _attBtn.layer.cornerRadius = 8;
        [_attBtn addTarget:self action:@selector(clickAttBtn:) forControlEvents:UIControlEventTouchUpInside];
        //        _attButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return _attBtn;
}

@end


















































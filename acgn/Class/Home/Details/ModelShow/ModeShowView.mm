//
//  ModeShowView.m
//  acgn
//
//  Created by Ares on 2018/3/13.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ModeShowView.h"
#import "PopAlertView.h"
@interface ModeShowView ()
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) NSArray *rightTitleArray;

@end

@implementation ModeShowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftArray = [NSArray arrayWithObjects:@"ms_l_icon_1",@"ms_l_icon_2",@"ms_l_icon_3",@"ms_l_icon_4", nil];
        self.rightArray = [NSArray arrayWithObjects:@"ms_r_icon_1",@"ms_r_icon_2",@"ms_r_icon_3",@"ms_r_icon_4", nil];
        self.rightTitleArray = [NSArray arrayWithObjects:@"活 动",@"福 利",@"道 具",@"信 息", nil];
        [self loadUI];
    }
    return self;
}

- (void)clickButton:(id)sender {
    
    PopAlertView *xlAlertView = [[PopAlertView alloc] initWithTitle:@"亲密度不足"];
    xlAlertView.resultIndex = ^(NSInteger index){
        //回调---处理一系列动作
    };
    [xlAlertView showXLAlertView];
    
 
    
    if ([self.delegate respondsToSelector:@selector(clickModeShowButton:)]) {
        [self.delegate clickModeShowButton:sender];
    }
}

- (void)loadUI {
    [self addSubview:self.bgImageView];
    [self addSubview:self.defaultShowImageView];
    [self addSubview:self.progressView];
    [self addSubview:self.bottomView];
    [self addSubview:self.bLeftView];
    [self addSubview:self.bRightView];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    self.progressView.backgroundColor = [UIColor blackColor];
    self.progressView.alpha = .5;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self).mas_offset(0);
        make.top.mas_equalTo(self).mas_offset(0);
    }];
    [self.defaultShowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.mas_right).mas_offset(-0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-[ATools setViewFrameBottomForIPhoneX:30]);
        make.top.mas_equalTo(self).mas_offset([ATools setViewFrameYForIPhoneX:0]);
//        make.top.mas_equalTo(self).mas_offset([ATools setViewFrameYForIPhoneX:64]);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self).mas_offset(0);
        make.height.mas_offset([ATools setViewFrameBottomForIPhoneX:30]);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-30);
        make.height.mas_offset(212-100);
    }];
    [self.bLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-130);
        make.height.mas_offset(212-140);
        make.width.mas_offset(65+20);
    }];
    [self.bRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
        make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-130);
        make.height.mas_offset(212-140);
        make.width.mas_offset(65+20);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(18);
        make.bottom.mas_equalTo(self.bLeftView.mas_top).mas_offset(-20);
        make.height.mas_offset(232);
        make.width.mas_offset(38);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-18);
        make.bottom.mas_equalTo(self.bRightView.mas_top).mas_offset(-20);
        make.height.mas_offset(232);
        make.width.mas_offset(38);
    }];
    
    [self loadProgressSubView];
    [self loadBottomSubViews];
    [self loadSubButtons:self.leftArray direction:YES roorView:self.leftView];
    [self loadSubButtons:self.rightArray direction:NO roorView:self.rightView];
}

- (void)loadProgressSubView {
    self.bottomProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(18, 14, self.frame.size.width-18*2, 7)];
    _bottomProgressView.progressImage = [UIImage imageNamed:@"jindu_progress_"];//[UIColor whiteColor];
    _bottomProgressView.trackImage = [UIImage imageNamed:@"jindu_progress_bg_"];
    _bottomProgressView.progress = 0.01;
    [self.progressView addSubview:_bottomProgressView];
}

- (void)loadBottomSubViews {
    UIButton *storyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    storyButton.frame = CGRectMake(self.frame.size.width/2-99-10, 0, 99, 99);
    [storyButton setImage:[UIImage imageNamed:@"ms_big_icon_3"] forState:UIControlStateNormal];
    [storyButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    storyButton.tag = 3000;
    [self.bottomView addSubview:storyButton];
    UIButton *dymaicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dymaicButton.frame = CGRectMake(self.frame.size.width/2+10, 0, 99, 99);
    [dymaicButton setImage:[UIImage imageNamed:@"ms_big_icon_2"] forState:UIControlStateNormal];
    [dymaicButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    dymaicButton.tag = 3001;
    [self.bottomView addSubview:dymaicButton];
    UIButton *wardrobeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wardrobeButton.frame = CGRectMake(20, 0, 65, 65);
    [wardrobeButton setImage:[UIImage imageNamed:@"ms_big_icon_1"] forState:UIControlStateNormal];
    [wardrobeButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    wardrobeButton.tag = 3002;
    [self.bLeftView addSubview:wardrobeButton];
    UIButton *taskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    taskButton.frame = CGRectMake(0, 0, 65, 65);
    [taskButton setImage:[UIImage imageNamed:@"ms_big_icon_4"] forState:UIControlStateNormal];
    [taskButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    taskButton.tag = 3003;
    [self.bRightView addSubview:taskButton];
//    self.bottomView.backgroundColor = [UIColor redColor];
//    self.bRightView.backgroundColor = [UIColor yellowColor];
//    self.bLeftView.backgroundColor = [UIColor greenColor];
}

- (void)loadSubButtons:(NSArray *)array direction:(BOOL)left roorView:(UIView *)rV {
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*38+i*20, 38, 38);
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = (left == YES)?(1000+i):(2000+i);
        if (!left) {
            [btn setTitle:[self.rightTitleArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [ATools setButtonContentCenter:btn];
            //btn.backgroundColor = [UIColor redColor];
        }
        [rV addSubview:btn];
    }
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"ms_back_view"];
    }
    return _bgImageView;
}

- (UIImageView *)defaultShowImageView {
    if (_defaultShowImageView == nil) {
        _defaultShowImageView = [[UIImageView alloc] init];
        _defaultShowImageView.image = [UIImage imageNamed:@"default_model_Image"];
        _defaultShowImageView.clipsToBounds = YES;
        _defaultShowImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _defaultShowImageView;
}

- (UIView *)leftView {
    if (_leftView == nil) {
        _leftView = [[UIView alloc] init];
        _leftView.backgroundColor = [UIColor clearColor];
    }
    return _leftView;
}
- (UIView *)rightView {
    if (_rightView == nil) {
        _rightView = [[UIView alloc] init];
        _rightView.backgroundColor = [UIColor clearColor];
    }
    return _rightView;
}
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}
- (UIView *)bLeftView {
    if (_bLeftView == nil) {
        _bLeftView = [[UIView alloc] init];
        _bLeftView.backgroundColor = [UIColor clearColor];
    }
    return _bLeftView;
}
- (UIView *)bRightView {
    if (_bRightView == nil) {
        _bRightView = [[UIView alloc] init];
        _bRightView.backgroundColor = [UIColor clearColor];
    }
    return _bRightView;
}
- (UIView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}


@end

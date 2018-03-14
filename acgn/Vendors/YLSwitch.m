//
//  YLSwitch.m

#import "YLSwitch.h"
@interface YLSwitch ()

@property (nonatomic,strong) UIButton *leftButton;//左侧按钮
@property (nonatomic,strong) UIButton *rightButton;//右侧按钮
@property (nonatomic,strong) UIButton *thumbView;//滑块
@property (nonatomic,strong) NSString *leftTitles;//左标题
@property (nonatomic,strong) NSString *rightTitles;//右标题
@end

@implementation YLSwitch

#pragma mark -- init

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setLeftAndRightButton];
        self.backgroundColor = UIColorFromRGB(0xE96A79); //[UIColor colorWithRed:243/255. green:143/255. blue:179/255. alpha:1.];
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.;
    }
    return self;
}

- (void)setLeftAndRightButton {

    self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];

    self.leftButton.frame = CGRectMake(0, 1, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 2);

    self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.rightButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 2, 1, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 2);

    [self.leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.rightButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];


    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];

    self.thumbView = [UIButton buttonWithType:UIButtonTypeSystem];
    self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);
    self.thumbView.layer.cornerRadius = CGRectGetHeight(self.thumbView.frame) / 2.;
    self.thumbView.backgroundColor = [UIColor whiteColor];

    //取消闪烁
    self.thumbView.adjustsImageWhenHighlighted = NO;
    self.rightButton.adjustsImageWhenHighlighted = NO;
    self.leftButton.adjustsImageWhenHighlighted = NO;

    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    [self.leftButton setTitle:@"" forState:UIControlStateNormal];
    [self.thumbView setTitle:@"" forState:UIControlStateNormal];

    //字体颜色
    UIColor *blackColor = [UIColor whiteColor];
    [self.thumbView setTitleColor:UIColorFromRGB(0xE96A79) forState:UIControlStateNormal];
    [self.leftButton setTitleColor:blackColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:blackColor forState:UIControlStateNormal];


    [self addSubview:self.thumbView];

    //拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(change:)];
    [self.thumbView addGestureRecognizer:panGesture];
}


#pragma mark -- PanGestureRecognizerEvent

- (void)change:(UIPanGestureRecognizer *)sender {

    CGPoint point = [sender translationInView:self.thumbView];

     //向右
    if (point.x > 0) {

        //不能超过范围
        if (point.x > CGRectGetWidth(self.thumbView.frame)) {
            point.x = CGRectGetWidth(self.thumbView.frame);
        }
        self.thumbView.frame = CGRectMake(point.x, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);


        //停止了拖动
        if ([sender state] == UIGestureRecognizerStateEnded) {


            if (point.x >= CGRectGetWidth(self.thumbView.frame) / 2) {

                self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);
                [self.thumbView setTitle:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text forState:UIControlStateNormal];

                [self.delegate switchState:self rightTitle:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text];

            }else {

                self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1,CGRectGetHeight(self.frame) - 2);

            }
        }

    }else {

        //向左
        if (point.x < -CGRectGetWidth(self.thumbView.frame)) {
            point.x = -CGRectGetWidth(self.thumbView.frame);
        }
        self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 + point.x - 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);

        //停止了拖动

        if ([sender state] == UIGestureRecognizerStateEnded) {

            if (point.x <= -CGRectGetWidth(self.thumbView.frame) / 2) {

                self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1,CGRectGetHeight(self.frame) - 2);
                [self.thumbView setTitle:_leftTitles != nil?_leftTitles:self.leftButton.titleLabel.text forState:UIControlStateNormal];
                [self.delegate switchState:self leftTitle:_leftTitles != nil?_leftTitles:self.leftButton.titleLabel.text];
            }else {

                self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);

            }
        }

    }

}

#pragma mark -- set/get...

- (void)setLeftTitle:(NSString *)leftTitle{
    _leftTitles = leftTitle;
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    if (_isSelectedIndex == 0) {
         [self.thumbView setTitle:leftTitle forState:UIControlStateNormal];
    }
}

- (void)setRightTitle:(NSString *)rightTitle{

    _rightTitles = rightTitle;
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    if (_isSelectedIndex == 1) {
        [self.thumbView setTitle:rightTitle forState:UIControlStateNormal];
    }
    
}

- (void)setBgColor:(UIColor *)bgColor {

    self.backgroundColor = bgColor;
}

- (void)setThumbColor:(UIColor *)thumbColor {

    self.thumbView.backgroundColor = thumbColor;
}
#pragma mark -- 左右两侧点击事件

- (void)leftButton:(UIButton *)button {
    [self moveToLeft];
    [self.delegate switchState:self leftTitle:_leftTitles != nil?_leftTitles:self.leftButton.titleLabel.text];
}

- (void)rightButton:(UIButton *)button {
    [self moveToRight];
    [self.delegate switchState:self rightTitle:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text];
}

- (void)moveToLeft {
    _isSelectedIndex = 0;
    //向左
    [self.thumbView setTitle:_leftTitles != nil ? _leftTitles : self.leftButton.titleLabel.text forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)moveToRight {
    _isSelectedIndex = 1;
    //向右
    [self.thumbView setTitle:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 -1 + 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end













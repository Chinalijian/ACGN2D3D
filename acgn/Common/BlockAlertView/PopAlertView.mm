//
//  PopAlertView.m
//  acgn
//
//  Created by lijian on 2018/3/13.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "PopAlertView.h"
///alertView  宽
#define AlertW 198
///各个栏目之间的距离
#define XLSpace 10.0

@interface PopAlertView()

@property (nonatomic, strong) UIView *bgV;
//弹窗
@property (nonatomic,retain) UIView *alertView;
//title
@property (nonatomic,retain) UILabel *titleLbl;

@end



@implementation PopAlertView
- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.bgV .backgroundColor = [UIColor blackColor];
        self.bgV .alpha = 0.5;
        [self addSubview:self.bgV];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 150);
        self.alertView.layer.position = self.center;
        
        UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake((self.alertView.frame.size.width-30)/2, 20, 30, 26)];
        imageLogo.image = [UIImage imageNamed:@"ms_qinmidu_icon"];
        [self.alertView addSubview:imageLogo];
        
        if (title) {
            
            self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(XLSpace, imageLogo.frame.size.height+imageLogo.frame.origin.y+20, AlertW-2*XLSpace, 20)];
            self.titleLbl.text = title;
            self.titleLbl.textColor = [UIColor blackColor];
            self.titleLbl.font = [UIFont systemFontOfSize:15];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            
        }
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        backButton.backgroundColor = UIColorFromRGB(0xE96A79);
        backButton.frame = CGRectMake((self.alertView.frame.size.width-62)/2, self.alertView.frame.size.height-32-15, 62, 32);
        backButton.layer.cornerRadius = 16;
        [backButton addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:backButton];
        
        [self addSubview:self.alertView];
        
        self.bgV.userInteractionEnabled = YES;
        //创建手势对象
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tapAction:)];
        //配置属性
        //轻拍次数
        tap.numberOfTapsRequired =1;
        //轻拍手指个数
        tap.numberOfTouchesRequired =1;
        //讲手势添加到指定的视图上
        [self.bgV addGestureRecognizer:tap];
    }
    
    return self;
}
//轻拍事件

-(void)tapAction:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

- (void)clickBackBtn:(id)sender {
    [self removeFromSuperview];
}

#pragma mark - 弹出 -
- (void)showXLAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.bgV.frame = self.bounds;
    self.alertView.layer.position = CGPointMake(self.center.x, self.center.y+self.alertView.frame.size.height/2);// self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
\

@end

#import "DMActivityView.h"

@interface DMActivityView ()

@property (nonatomic, strong) CAReplicatorLayer *reaplicator;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CALayer *showlayer;

@end

static DMActivityView *activiyView;
@implementation DMActivityView

+ (void)showActivity:(UIView *)supperView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (activiyView == nil) {
            activiyView = [[self alloc] init];
        }
    });
    
    activiyView.backgroundColor = [UIColor clearColor];
    [activiyView showInView:supperView];
}

+ (void)showActivity:(UIView *)supperView hudColor:(UIColor *)backgroundColor {
    [self showActivity:supperView];
    activiyView.backgroundColor = backgroundColor;
}

+ (void)showActivityCover:(UIView *)supperView {
    [self showActivity:supperView hudColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
}

+ (void)hideActivity {
    [activiyView hide];
}

- (void)showInView:(UIView *)supperView {
    [supperView addSubview:self];
    self.alpha = 1;
    [self setupMakeLayoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupMakeLayoutSubviews];
}

- (void)setupMakeLayoutSubviews {
    [self.superview layoutIfNeeded];
    self.frame = self.superview.bounds;
    self.contentView.center = self.center;
}

- (void)hide {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.showTimes = 0;
        [self.contentView.layer addSublayer:self.reaplicator];
        [self addSubview:self.contentView];
        [self startAnimation];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}
- (void)startAnimation {
    //对layer进行动画设置
    CABasicAnimation *animaiton = [CABasicAnimation animation];
    //设置动画所关联的路径属性
    animaiton.keyPath = @"transform.scale";
    //设置动画起始和终结的动画值
    animaiton.fromValue = @(1);
    animaiton.toValue = @(0.1);
    //设置动画时间
    animaiton.duration = 1.0f;
    //填充模型
    animaiton.fillMode = kCAFillModeForwards;
    //不移除动画
    animaiton.removedOnCompletion = NO;
    //设置动画次数
    animaiton.repeatCount = INT_MAX;
    //添加动画
    [self.showlayer addAnimation:animaiton forKey:@"anmation"];
}
- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        //        contentView.layer.cornerRadius = 10.0f;
        //        contentView.layer.borderColor = [UIColor colorWithWhite:0.926 alpha:1.000].CGColor;
        //        contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        //        contentView.layer.shadowOpacity = 0.1;
        //        contentView.layer.shadowOffset = CGSizeMake(1, 1);
        //        contentView.backgroundColor = [UIColor whiteColor];
        _contentView = contentView;
    }
    return _contentView;
}

- (CAReplicatorLayer *)reaplicator{
    if (_reaplicator == nil) {
        int numofInstance = 10;
        CGFloat duration = 1.0f;
        //创建repelicator对象
        CAReplicatorLayer *repelicator = [CAReplicatorLayer layer];
        repelicator.bounds = CGRectMake(0, 0, 50, 50);
        repelicator.position = CGPointMake(self.contentView.bounds.size.width * 0.5, self.contentView.bounds.size.height * 0.5);
        repelicator.instanceCount = numofInstance;
        repelicator.instanceDelay = duration / numofInstance;
        //设置每个实例的变换样式
        repelicator.instanceTransform = CATransform3DMakeRotation(M_PI * 2.0 / 10.0, 0, 0, 1);
        //创建repelicator对象的子图层，repelicator会利用此子图层进行高效复制。并绘制到自身图层上
        CALayer *layer = [CALayer layer];
        CGFloat layerWH = 8;
        layer.frame = CGRectMake(0, 0, layerWH, layerWH);
        //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此
        CGPoint point = [repelicator convertPoint:repelicator.position fromLayer:self.layer];
        layer.position = CGPointMake(point.x, point.y - 20);
#warning 修改等待提示颜色
        layer.backgroundColor = UIColorFromRGB(0xFFFFFF).CGColor;
        
        layer.cornerRadius = layerWH * 0.5;
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showlayer = layer;
        //将子图层添加到repelicator上
        [repelicator addSublayer:layer];
        _reaplicator = repelicator;
    }
    return _reaplicator;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end


//
//  AboutViewController.m
//  acgn
//
//  Created by lijian on 2018/2/4.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic, strong) ComonTop *topView;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation AboutViewController
#define TopView_H 198
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    [self.view addSubview:self.topView];

    [self.view addSubview:self.infoLabel];
}

- (ComonTop *)topView {
    if (_topView == nil) {
        _topView = [[ComonTop alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TopView_H)];
        _topView.logoNameLabel.text = @"加一次元";
    }
    return _topView;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        NSString *textStr = @"      霍尔果斯加一次元数字科技有限公司是中国知名的动漫网络运营及内容制作企业，公司致力于打造全方位服务作者的一体化推广服务平台。\n\n      公司以互联网动漫版权业务为核心，利用互联网平台优势，不断的在网站业务、移动业务、漫画、动画、游戏领域持续深挖新的新模式，使作者、作品有更好的推广运营办法力求成为中国动漫产业的源头砥柱型企业。";
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, TopView_H+30, self.view.frame.size.width-40, DMScreenHeight-TopView_H-10)];
        _infoLabel.text = textStr;
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.textColor = [UIColor blackColor];
        _infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _infoLabel.numberOfLines = 0;
        NSDictionary *dic = @{NSKernAttributeName:@0.f};
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:textStr attributes:dic];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:12.5];//行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
        [_infoLabel setAttributedText:attributedString];
        [_infoLabel sizeToFit];
    }
    return _infoLabel;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self setNavigationBarTransparence:YES titleColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

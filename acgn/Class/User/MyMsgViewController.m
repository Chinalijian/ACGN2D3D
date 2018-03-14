//
//  MyMsgViewController.m
//  acgn
//
//  Created by lijian on 2018/2/5.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "MyMsgViewController.h"
#import "YLSwitch.h"
#import "ContentBaseViewController.h"
#import "MulCategoryScrollView.h"
@interface MyMsgViewController ()<YLSwitchDelegate>

@property (nonatomic, strong) NSMutableArray *categoryCtrNameArray;
@property (nonatomic, strong) NSMutableArray *categoryCtrArray;
@property (nonatomic, strong) MulCategoryScrollView *mulCSV;
@property (nonatomic, strong) YLSwitch *mySwitch;
@property (nonatomic, strong) UIImageView *topView;
@end

@implementation MyMsgViewController
#define ReplayMy        @"ReplayMineViewController"
#define MySend          @"MySendViewController"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的消息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTransparence:YES
                            titleColor:[UIColor whiteColor]];
    [self loadUI];
}

- (void)loadUI {
    self.topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, [ATools setViewFrameYForIPhoneX:107])];
    self.topView.image = [UIImage imageNamed:@"user_msg_top_icon"];
    [self.view addSubview:self.topView];
    self.topView.userInteractionEnabled = YES;
    self.mySwitch = [[YLSwitch alloc] initWithFrame:CGRectMake((DMScreenWidth-182)/2, [ATools setViewFrameYForIPhoneX:64+7], 182, 30)];
    self.mySwitch.tag = 1;
    self.mySwitch.isSelectedIndex = 0;
    self.mySwitch.delegate = self;
    self.mySwitch.leftTitle = @"吐槽我的";
    self.mySwitch.rightTitle = @"我发出的";
    //self.navigationItem.titleView  = self.mySwitch;
    [self.topView addSubview:self.mySwitch];
    
    [self addMulCategoryScrollView];
}
#pragma mark -- YLSwitchDelegate
- (void)switchState:(UIView *)view leftTitle:(NSString *)title {
    if (view.tag == 1) {
        NSLog(@"导航栏switch");
        [self.mulCSV clickIndex:0];
    }
    NSLog(@"%@",title);
}

- (void)switchState:(UIView *)view rightTitle:(NSString *)title {
    if (view.tag == 1) {
        NSLog(@"导航栏switch");
        [self.mulCSV clickIndex:1];
    }
    NSLog(@"%@",title);
}

- (void)addMulCategoryScrollView {
    self.categoryCtrNameArray = [NSMutableArray arrayWithObjects:ReplayMy, MySend, nil];
    self.categoryCtrArray = [NSMutableArray array];
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (int i = 0; i<[self.categoryCtrNameArray count]; i++) {
        ContentBaseViewController *ctr = [[NSClassFromString([self.categoryCtrNameArray objectAtIndex:i]) alloc] init];
        [self.categoryCtrArray addObject:ctr];
        [viewsArray addObject:ctr.view];
        [self addChildViewController:ctr];
    }
    CGRect rect = CGRectMake(0, self.topView.frame.size.height, self.view.frame.size.width, DMScreenHeight-self.topView.frame.size.height);
    __weak typeof(self)bsel = self;
    self.mulCSV = [[MulCategoryScrollView alloc] initWithFrame:rect andViews:viewsArray andIndexBlock:^(int index) {
        NSLog(@"滑动进来了");
        if (index == 0) {
            [bsel.mySwitch moveToLeft];
        } else if (index == 1) {
            [bsel.mySwitch moveToRight];
        }
    }];
    [self.view addSubview:self.mulCSV];
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

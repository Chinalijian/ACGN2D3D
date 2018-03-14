//
//  HomeViewController.m
//  acgn
//
//  Created by Ares on 2018/2/1.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "HomeViewController.h"
#import "AttentionPeopleList.h"
#import "UserViewController.h"
#import "YLSwitch.h"
#import "ContentBaseViewController.h"
#import "MulCategoryScrollView.h"
@interface HomeViewController () <YLSwitchDelegate>

@property (nonatomic, strong) NSMutableArray *categoryCtrNameArray;
@property (nonatomic, strong) NSMutableArray *categoryCtrArray;
@property (nonatomic, strong) MulCategoryScrollView *mulCSV;
@property (nonatomic, strong) YLSwitch *mySwitch;

@end

@implementation HomeViewController
#define H_AttentVC        @"AttentViewController"
#define H_SquareVC        @"SquareViewController"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRigthBtn:CGRectMake(0, 0, 44, 44) title:@"" titileColor:nil imageName:@"user_icon" font:nil];
    [self loadUI];
}

- (void)rightOneAction:(id)sender {
    UserViewController *userVC = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];
}


- (void)loadUI {
    
    self.mySwitch = [[YLSwitch alloc] initWithFrame:CGRectMake(0, 0, 128, 30)];
    self.mySwitch.tag = 1;
    self.mySwitch.isSelectedIndex = 0;
    self.mySwitch.delegate = self;
    self.mySwitch.leftTitle = @"关注";
    self.mySwitch.rightTitle = @"广场";
    self.navigationItem.titleView  = self.mySwitch;

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
    self.categoryCtrNameArray = [NSMutableArray arrayWithObjects:H_AttentVC, H_SquareVC, nil];
    self.categoryCtrArray = [NSMutableArray array];
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (int i = 0; i<[self.categoryCtrNameArray count]; i++) {
        ContentBaseViewController *ctr = [[NSClassFromString([self.categoryCtrNameArray objectAtIndex:i]) alloc] init];
        [self.categoryCtrArray addObject:ctr];
        [viewsArray addObject:ctr.view];
        [self addChildViewController:ctr];
    }
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, DMScreenHeight-64);
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //[self.navigationController setNavigationBarHidden:NO];
    //[self setNavigationBarTransparence:NO titleColor:[UIColor blackColor]];
    [self useMethodToFindBlackLineAndHind:NO];
    [self setNavigationBarTransparence:NO titleColor:[UIColor blackColor]];
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

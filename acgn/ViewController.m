//
//  ViewController.m
//  acgn
//
//  Created by Ares on 2018/1/25.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <LUNSegmentedControlDataSource, LUNSegmentedControlDelegate>
@property (nonatomic, strong) LUNSegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-258)/2, 100, 258, 60)];
    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    self.segmentedControl = [[LUNSegmentedControl alloc] init];
    self.segmentedControl.dataSource = self;
    self.segmentedControl.delegate = self;
    self.segmentedControl.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.segmentedControl];
    
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(50);
    }];
    
    self.segmentedControl.transitionStyle = LUNSegmentedControlTransitionStyleFade;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self segmentedControl:self.segmentedControl didScrollWithXOffset:0];
}
- (NSArray<UIColor *> *)segmentedControl:(LUNSegmentedControl *)segmentedControl gradientColorsForStateAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @[[UIColor colorWithRed:160 / 255.0 green:223 / 255.0 blue:56 / 255.0 alpha:1.0], [UIColor colorWithRed:177 / 255.0 green:255 / 255.0 blue:0 / 255.0 alpha:1.0]];
            
            break;
            
        case 1:
            return @[[UIColor colorWithRed:78 / 255.0 green:252 / 255.0 blue:208 / 255.0 alpha:1.0], [UIColor colorWithRed:51 / 255.0 green:199 / 255.0 blue:244 / 255.0 alpha:1.0]];
            break;
            
        case 2:
            return @[[UIColor colorWithRed:178 / 255.0 green:0 / 255.0 blue:235 / 255.0 alpha:1.0], [UIColor colorWithRed:233 / 255.0 green:0 / 255.0 blue:147 / 255.0 alpha:1.0]];
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfStatesInSegmentedControl:(LUNSegmentedControl *)segmentedControl {
    return 3;
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForStateAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"TAB %li",(long)index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16]}];
}

- (NSAttributedString *)segmentedControl:(LUNSegmentedControl *)segmentedControl attributedTitleForSelectedStateAtIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"TAB %li",(long)index] attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]}];
}


- (void)segmentedControl:(LUNSegmentedControl *)segmentedControl didScrollWithXOffset:(CGFloat)offset {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

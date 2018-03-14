//
//  MulCategoryScrollView.h
//  acgn
//
//  Created by Ares on 2018/1/25.
//  Copyright © 2018年 Jian LI. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^MulCategoryIndexChangeBlock)(int);

@interface MulCategoryScrollView : UIView<UIScrollViewDelegate>{
    int lastIndex;
}

@property(nonatomic,strong)NSArray *svVeiws;
@property(nonatomic,strong)UIScrollView *viewScroll;

@property(nonatomic,strong)UIViewController *parentCtr;

@property(nonatomic,copy)MulCategoryIndexChangeBlock indexChangeBlock;
- (void)setIndexChangeBlock:(MulCategoryIndexChangeBlock)aIndexChangeBlock;
- (void)clickIndex:(int)index;
- (instancetype)initWithFrame:(CGRect)frame andViews:(NSArray *)views andIndexBlock:(void(^)(int index))indexChangeBlock;

@end

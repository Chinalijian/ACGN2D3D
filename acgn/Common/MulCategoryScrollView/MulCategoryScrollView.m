//
//  MulCategoryScrollView.h
//  acgn
//
//  Created by Ares on 2018/1/25.
//  Copyright © 2018年 Jian LI. All rights reserved.
//
#import "MulCategoryScrollView.h"

@implementation MulCategoryScrollView

- (void)setIndexChangeBlock:(MulCategoryIndexChangeBlock)aIndexChangeBlock {
    _indexChangeBlock = [aIndexChangeBlock copy];
}

- (instancetype)initWithFrame:(CGRect)frame andViews:(NSArray *)views andIndexBlock:(void(^)(int index))indexChangeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        lastIndex = 0;
        self.svVeiws = views;
        self.indexChangeBlock = indexChangeBlock;
        [self initViewScroll];
        if (_indexChangeBlock) {
            _indexChangeBlock(0);
        }
    }
    return self;
}

- (void)initViewScroll{
    //views
    self.viewScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.viewScroll.delegate = self;
    self.viewScroll.showsHorizontalScrollIndicator =NO;
    self.viewScroll.showsVerticalScrollIndicator =NO;
    self.viewScroll.bounces =YES;
    self.viewScroll.contentOffset=CGPointZero;
    self.viewScroll.scrollsToTop =NO;
    self.viewScroll.pagingEnabled = YES;
    [self.viewScroll setContentSize:CGSizeMake(self.frame.size.width*[_svVeiws count], self.viewScroll.frame.size.height)];
    
    for (int i = 0; i<[_svVeiws count]; i++) {
        UIView *view = [_svVeiws objectAtIndex:i];
        view.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self.viewScroll addSubview:view];
    }

    [self addSubview:self.viewScroll];
}


#pragma mark- scrollView
//滚动过程中获取当前索引
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = ([scrollView contentOffset].x+scrollView.frame.size.width/2)/scrollView.frame.size.width;
    if (index>=0 && index<[_svVeiws count]) {
        if ([self indexChanged:index]) {
            [self callBackWithIndex:index];
        }
    }
}

- (BOOL)indexChanged:(int)index {
    if (lastIndex !=index) {
        lastIndex = index;
        return YES;
    }
    return NO;
}

- (void)callBackWithIndex:(int)index {
    if (_indexChangeBlock) {
        _indexChangeBlock(index);
    }
}

//click
- (void)clickIndex:(int)index {
    if ([self indexChanged:index]) {
        [self callBackWithIndex:index];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.viewScroll.contentOffset = CGPointMake(lastIndex*self.viewScroll.frame.size.width, 0);
    }];
}


@end

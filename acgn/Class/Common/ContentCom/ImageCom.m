//
//  ImageCom.m
//  acgn
//
//  Created by lijian on 2018/2/8.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "ImageCom.h"
#import "JLPhotoBrowser.h"
@interface ImageCom()
@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, strong) UIImageView *bigSourceImageView;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UIButton *videoIconView;
@property (nonatomic, strong) UIView *smallImageView;

@property (nonatomic, assign) CGFloat bWidth;
@property (nonatomic, assign) CGFloat bHeight;
@property (nonatomic, assign) CGFloat sWidth;
@property (nonatomic, assign) CGFloat sHeight;
@property (nonatomic, assign) CGFloat sSpace;

@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHight;
/**
 *  imageViews
 */
@property (nonatomic, strong) NSMutableArray *imageViews;
/**
 *  URL数组
 */
@property (nonatomic, strong) NSMutableArray *bigImgUrls;

@property (nonatomic, assign) Info_Type typeInfo;
@property (nonatomic, strong) UILabel *gifLabel;

@end

@implementation ImageCom
- (id)initWithBigImage:(CGFloat)width
        bigImageHeight:(CGFloat)height
       smallImageWidth:(CGFloat)swidth
      samllImageHeight:(CGFloat)sheight
            smallSpace:(CGFloat)sspace
                frameW:(CGFloat)frameW
                frameH:(CGFloat)frameH {
    self = [super init];
    if (self) {
        self.bWidth = width;
        self.bHeight = height;
        self.sWidth = swidth;
        self.sHeight = sheight;
        self.sSpace = sspace;
        self.frameHight = frameH;
        self.frameWidth = frameW;
        [self initSubViewsForImage];
    }
    return self;
}

- (void)onlySinglePic:(NSString *)imageUrl height:(CGFloat)height {
    
    self.bigImageView.frame = CGRectMake(0, 0, self.bigImageView.frame.size.width, height);
    //self.bigImageView.backgroundColor = [UIColor redColor];
    self.smallImageView.hidden = YES;
    self.bigImageView.hidden = NO;
    self.typeLabel.hidden = YES;
    self.videoIconView.hidden = YES;
    NSString * imageUrlS = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self displaySourceImage:imageUrlS];
    self.bigImageView.userInteractionEnabled = YES;
    //2.添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [_bigImageView addGestureRecognizer:tap];
    if (_typeInfo == Info_Type_GIf_Pic) {
        if ([[imageUrlS lastPathComponent] containsString:@".gif"]) {
            self.typeLabel.text = @"GIF";
            self.typeLabel.hidden = NO;
        } else {
            self.typeLabel.text = @"";
            self.typeLabel.hidden = YES;
        }
    } else if (_typeInfo == Info_Type_Video || _typeInfo == Info_Type_Url_Video) {
        if (!STR_IS_NIL(self.viedoTime)) {
            self.typeLabel.text = self.viedoTime;
            self.typeLabel.hidden = NO;
            self.videoIconView.hidden = NO;
        } else {
            self.typeLabel.text = @"未知";
            self.typeLabel.hidden = NO;
            self.videoIconView.hidden = NO;
        }
    }
}

- (void)cleanSubObj {
    self.smallImageView.frame = CGRectZero;
    self.bigImageView.frame = CGRectZero;
    self.smallImageView.hidden = YES;
    self.bigImageView.hidden = YES;
    self.typeLabel.hidden = YES;
    self.videoIconView.hidden = YES;
}

- (void)configImageCom:(NSArray *)array height:(CGFloat)height type:(Info_Type)type thumbnailUrl:(NSString *)thumbnailUrl {
    self.typeInfo = type;
    [self.bigImgUrls removeAllObjects];
    [self.imageViews removeAllObjects];
    if (self.typeInfo == Info_Type_Video || self.typeInfo == Info_Type_Url_Video) { //视频
        if ((![array isKindOfClass:[NSArray class]] || OBJ_IS_NIL(array) || array.count == 0) && STR_IS_NIL(thumbnailUrl)) {
            [self cleanSubObj];
        } else {
            [self.bigImgUrls addObjectsFromArray: array];
            self.smallImageView.frame = CGRectMake(0, 0, self.smallImageView.frame.size.width, height);
            [self onlySinglePic:thumbnailUrl height:height];
        }
        
    } else {
        //图片
        if ((![array isKindOfClass:[NSArray class]] || OBJ_IS_NIL(array) || array.count == 0)) {
            [self cleanSubObj];
        } else {
            [self.bigImgUrls addObjectsFromArray: array];
            self.smallImageView.frame = CGRectMake(0, 0, self.smallImageView.frame.size.width, height);
            NSInteger imageCount = [array count];

            if (imageCount == 1) {
                NSString *url = [array firstObject];
                [self onlySinglePic:url height:height];
            } else {
                self.bigImageView.frame = CGRectMake(0, 0, self.bigImageView.frame.size.width, 0);
                self.smallImageView.hidden = NO;
                self.typeLabel.hidden = YES;
                self.bigImageView.hidden = YES;
                self.videoIconView.hidden = YES;
                for(UIView *view in [self.smallImageView subviews]) {
                    [view removeFromSuperview];
                }
                [self initSmallImages:array];
            }
        }
    }
}

- (void)displaySourceImage:(NSString *)url {
    WS(weakSelf);
    __weak __typeof(&*self.bigSourceImageView) weakImageView = self.bigSourceImageView;
    __weak __typeof(&*self.typeLabel) weakLabel = self.typeLabel;
    __weak __typeof(&*self.videoIconView) weakVideoIconView = self.videoIconView;
   
    [self.bigSourceImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:Default_Placeholder_Image options:SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //do something.....
            dispatch_async(dispatch_get_main_queue(), ^{
                __typeof(&*weakImageView) strongImageView = weakImageView;
                if (strongImageView) {
                    if (image != nil) {
                        //得到当前视图的frame
    
                        //得到当前Image的frame
                        CGSize imageSize = image.size;
                        //得到当前ImageView 的frame
                        CGRect imageVRect = strongImageView.frame;
                        //image的宽度大于当前视图的宽度
                        if(imageSize.width > weakSelf.bWidth)
                        {
                            //根据宽度计算高度，确定宽度
                            imageVRect.size.height = weakSelf.bWidth * imageSize.height / imageSize.width;
                            imageVRect.size.width = weakSelf.bWidth;
                        }
                        //image的高度大于当前视图的高度
                        if(imageVRect.size.height > weakSelf.bHeight)
                        {
                            
                            //根据高度计算宽度，确定宽度
                            imageVRect.size.width = weakSelf.bHeight * imageVRect.size.width / imageVRect.size.height;
                            imageVRect.size.height = weakSelf.bHeight;
                        }
                        
                        //计算x，y
                        imageVRect.origin.x = 0;//(weakSelf.bWidth-imageVRect.size.width)/2;
                        imageVRect.origin.y = 0;//(weakSelf.bHeight-imageVRect.size.height)/2;
                        strongImageView.frame = imageVRect;
                        if (weakSelf.typeInfo == Info_Type_Video || weakSelf.typeInfo == Info_Type_Url_Video) {
                            strongImageView.frame = CGRectMake(0, 0, weakSelf.bWidth, weakSelf.bHeight-8);
                            weakLabel.frame = CGRectMake(strongImageView.frame.size.width-35-4, strongImageView.frame.size.height-16-4, 35, 16);
                            weakVideoIconView.frame = CGRectMake((strongImageView.frame.size.width-38)/2, (strongImageView.frame.size.height-38)/2, 38, 38);
//                            weakLabel.frame = CGRectMake(imageVRect.size.width-35-4, imageVRect.size.height-16-4, 35, 16);
//                            weakVideoIconView.frame = CGRectMake((imageVRect.size.width-38)/2, (imageVRect.size.height-38)/2, 38, 38);
                        } else {
                            weakLabel.frame = CGRectMake(imageVRect.size.width-24-4, imageVRect.size.height-16-4, 24, 16);
                        }
                        strongImageView.image = image;
                        [weakSelf.imageViews addObject:strongImageView];
                        [strongImageView setNeedsLayout];
                    }
                    
                }
            });
        });
    }];
}

- (void)initSubViewsForImage {
    
    self.smallImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHight)];
    self.smallImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.smallImageView];
    
    self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bWidth, self.bHeight)];
    self.bigImageView.tag = 1000;
    self.bigImageView.clipsToBounds = YES;
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.bigImageView];
    
    self.bigSourceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.bigSourceImageView.tag = 9999;
    self.bigSourceImageView.clipsToBounds = YES;
    self.bigSourceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bigImageView addSubview:self.bigSourceImageView];
    
    self.videoIconView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoIconView.frame = CGRectMake(0, 0, 38, 38);
    self.videoIconView.backgroundColor = UIColorFromRGB(0x2D2D30);
    self.videoIconView.alpha = .5;
    [self.videoIconView setImage:[UIImage imageNamed:@"home_video_icon"] forState:UIControlStateNormal];
    //self.videoIconView.image = [UIImage imageNamed:@"home_video_icon"];
    self.videoIconView.userInteractionEnabled = NO;
    self.videoIconView.clipsToBounds = YES;
    self.videoIconView.layer.cornerRadius = 19;
    [self.bigSourceImageView addSubview:self.videoIconView];
    self.videoIconView.hidden = YES;
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 16)];
    _typeLabel.text = @"";
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.font = [UIFont systemFontOfSize:9];
    _typeLabel.backgroundColor = UIColorFromRGB(0x2D2D30);
    _typeLabel.alpha = .5;
    _typeLabel.clipsToBounds = YES;
    _typeLabel.layer.cornerRadius = 7;
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bigSourceImageView addSubview:self.typeLabel];
    self.typeLabel.hidden = YES;
    
    self.smallImageView.hidden = YES;
    self.bigImageView.hidden = YES;
}

- (void)initSmallImages:(NSArray *)array {
    CGFloat XX = _sSpace;
    CGFloat YY = _sSpace;
    for (int i = 0; i < array.count; i++) {
        if (i%3 == 0) {
            XX = _sSpace;
        } else {
            XX = _sSpace*(i%3)+_sSpace+_sWidth*(i%3);
        }
        if (i/3 == 0) {
            YY = _sSpace;
        } else {
            YY = _sSpace*(i/3)+_sSpace+_sHeight*(i/3);
        }
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(XX, YY, _sWidth, _sHeight)];
        imageV.tag = 1000+i;
        imageV.clipsToBounds = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.userInteractionEnabled = YES;
        [self.smallImageView addSubview:imageV];
        //2.添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageV addGestureRecognizer:tap];
        
        [self.imageViews addObject:imageV];
        
        NSString *url = [array objectAtIndex:i];
        NSString * imageUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Default_Placeholder_Image];

        
        if (_typeInfo == Info_Type_GIf_Pic) {
            if ([[imageUrl lastPathComponent] containsString:@".gif"]) {
                
                UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sWidth-24-4, _sHeight-16-4, 24, 16)];
                typeLabel.text = @"GIF";
                typeLabel.textColor = [UIColor whiteColor];
                typeLabel.font = [UIFont systemFontOfSize:9];
                typeLabel.backgroundColor = UIColorFromRGB(0x2D2D30);
                typeLabel.alpha = .5;
                typeLabel.clipsToBounds = YES;
                typeLabel.layer.cornerRadius = 7;
                typeLabel.textAlignment = NSTextAlignmentCenter;
                [imageV addSubview:typeLabel];
            }
        }
    }
}

#pragma mark 图片点击

-(void)imageTap:(UITapGestureRecognizer *)tap{
    
    if (self.typeInfo == Info_Type_Video) {
        //去视频播放器
        if ([self.delegate respondsToSelector:@selector(clickVideoImagePlay:videoUrl:)]) {
            [self.delegate clickVideoImagePlay:Info_Type_Video videoUrl:[self.bigImgUrls firstObject]];
        }
    } else if (self.typeInfo == Info_Type_Url_Video) {
        //去web页
        if ([self.delegate respondsToSelector:@selector(clickVideoImagePlay:videoUrl:)]) {
            [self.delegate clickVideoImagePlay:Info_Type_Url_Video videoUrl:[self.bigImgUrls firstObject]];
        }
    } else {
        
        //1.创建JLPhoto数组
        NSMutableArray *photos = [NSMutableArray array];
        
        for (int i=0; i<self.imageViews.count; i++) {
            
            UIImageView *child = self.imageViews[i];
            JLPhoto *photo = [[JLPhoto alloc] init];
            //1.1设置原始imageView
            photo.sourceImageView = child;
            //1.2设置大图URL
            photo.bigImgUrl = self.bigImgUrls[i];
            //1.3设置图片tag
            photo.tag = i;
            [photos addObject:photo];
            
        }
        
        //2. 创建图片浏览器
        JLPhotoBrowser *photoBrowser = [JLPhotoBrowser photoBrowser];
        photoBrowser.typeInfo = self.typeInfo;
        //2.1 设置JLPhoto数组
        photoBrowser.photos = photos;
        //2.2 设置当前要显示图片的tag
        photoBrowser.currentIndex = (int)tap.view.tag-1000;
        //2.3 显示图片浏览器
        [photoBrowser show];
    }

}

- (NSMutableArray *)imageViews {
    if (_imageViews==nil) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (NSMutableArray *)bigImgUrls {
    if (_bigImgUrls==nil) {
        _bigImgUrls = [NSMutableArray array];
    }
    return _bigImgUrls;
}

@end
















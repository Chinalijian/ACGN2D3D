//
//  YLSwitch.h

#import <UIKit/UIKit.h>

@protocol YLSwitchDelegate <NSObject>

@optional

/*
* 切换到左侧
 */
-(void)switchState:(UIView *)view leftTitle:(NSString *)title;
/*
 * 切换到右侧
 */
-(void)switchState:(UIView *)view rightTitle:(NSString *)title;

@end

@interface YLSwitch : UIView
/**
 *  公开属性
 */
@property (nonatomic,strong) NSString *rightTitle;//右侧标题    默认为 second

@property (nonatomic,strong) NSString *leftTitle;//左侧标题     默认为 frist

@property (nonatomic,strong) UIColor *bgColor;//背景颜色        默认为 粉色

@property (nonatomic,strong) UIColor *thumbColor;//滑块颜色     默认为 白色

@property (nonatomic,weak) id <YLSwitchDelegate> delegate;//切换代理

@property (nonatomic,assign) NSInteger isSelectedIndex;

- (void)moveToLeft;
- (void)moveToRight;

//注：  多个YLSwitch代理方法请使用tag进行调用区分

@end

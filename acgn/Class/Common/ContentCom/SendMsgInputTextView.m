//
//  SendMsgInputTextView.m
//  acgn
//
//  Created by Ares on 2018/2/12.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "SendMsgInputTextView.h"
@interface SendMsgInputTextView ()<UITextViewDelegate> {
    UIView *_bottomView;//评论框
    UITextView *_textView;//输入框
    UILabel *_textApl;//字数
    CGRect _rect;
    UILabel *_alpLabel;
}


@end

@implementation SendMsgInputTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [[IQKeyboardManager sharedManager] setEnable:NO];
        _rect = self.frame;
        
        [self initNotification];
        [self AddtextFieldComments];
    }
    return self;
}
- (void)rectFrame:(CGRect)rect {
     _rect = rect;
}

#pragma mark - 初始化键盘监听

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //监听键盘的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 初始化视图

- (void)AddtextFieldComments  {
    _bottomView = [[UIView alloc] initWithFrame:self.bounds];
    _bottomView.backgroundColor = UIColorFromRGB(0xF2F2F2);//self.bgColor;
    _bottomView.userInteractionEnabled= YES;
    [self addSubview:_bottomView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xBAB8B8);//[UIColor colorWithWhite:0.6 alpha:0.3];
    [_bottomView addSubview:lineView];
    
    UIView *editInfoView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, self.frame.size.width-15-88, 40)];
    editInfoView.layer.cornerRadius = 15;
    editInfoView.layer.borderWidth = 1;
    editInfoView.layer.borderColor = lineView.backgroundColor.CGColor;
    [_bottomView addSubview:editInfoView];
    
    UIImageView *editIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 26/2, 24, 24)];
    editIconImage.image = [UIImage imageNamed:@"edit_pen_icon"];
    [_bottomView addSubview:editIconImage];
    
    UILabel *alpLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, editInfoView.frame.origin.y, 100, editInfoView.frame.size.height)];
    alpLabel.text = @"各种吐槽尽管来";
    alpLabel.textColor = UIColorFromRGB(0x939393);
    alpLabel.font = [UIFont systemFontOfSize:13];
    alpLabel.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:alpLabel];
    _alpLabel = alpLabel;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(_alpLabel.frame.origin.x-2, 5, self.frame.size.width-50-88+2, 40)];
//    _textView.layer.cornerRadius = 15;
//    _textView.layer.borderWidth = 1;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
//    _textView.layer.borderColor = lineView.backgroundColor.CGColor;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.returnKeyType = UIReturnKeyDone;
    [_bottomView addSubview:_textView];
    
    
    _textApl = [[UILabel alloc] init];
    _textApl.frame = CGRectMake(CGRectGetMaxX(_textView.frame)-37, 35, 30, 6);
    _textApl.textColor = [UIColor grayColor];
    _textApl.textAlignment = NSTextAlignmentRight;
    _textApl.font = [UIFont systemFontOfSize:8];
    //    _textApl.text = @"140";
    [_bottomView addSubview:_textApl];
    
    UIButton *plBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    plBtn.layer.borderWidth = 1;
    plBtn.backgroundColor = UIColorFromRGB(0xE96A79);
    [plBtn setTitle:@"发送" forState:UIControlStateNormal];
    [plBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    plBtn.layer.cornerRadius = 20;
    plBtn.layer.borderColor = lineView.backgroundColor.CGColor;
    plBtn.frame = CGRectMake(CGRectGetMaxX(_textView.frame) + 10, CGRectGetMinY(_textView.frame), 62, CGRectGetHeight(_textView.frame));
    [plBtn addTarget:self action:@selector(pinglun) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:plBtn];
}

#pragma mark - get方法

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _bottomView.backgroundColor = bgColor;
}

- (void)setLimitNum:(NSInteger)limitNum {
    NSLog(@"%ld",limitNum);
    _limitNum = limitNum;
    _textApl.text = [NSString stringWithFormat:@"%ld",limitNum];
}

- (void)setShowLimitNum:(BOOL)showLimitNum {
    _showLimitNum = showLimitNum;
    if (showLimitNum) {
        _textApl.hidden = NO;
    }else {
        _textApl.hidden = YES;
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _textView.font = font;
}

- (void)cleanTextInfo {
    _textView.text = @"";
    _alpLabel.hidden = NO;
}

#pragma mark - 事件监听

- (void)pinglun {
    NSLog(@"发送  -》 %@", _textView.text);
    [self endEditing:YES];
    NSString *content = _textView.text;
    if (STR_IS_NIL(content)) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(inputContent:)]) {
        [self.delegate inputContent:content];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *textContent = textView.text;
    if (STR_IS_NIL(textContent)) {
        _alpLabel.hidden = NO;
    } else {
        _alpLabel.hidden = YES;
    }
    
    if (_showLimitNum) {
        NSString *toBeString = textView.text;
        NSArray *currentar = [UITextInputMode activeInputModes];
        UITextInputMode *current = [currentar firstObject];
        
        //下面的方法是iOS7被废弃的，注释
        //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        
        if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > _limitNum) {
                    textView.text = [toBeString substringToIndex:_limitNum];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > _limitNum) {
                textView.text = [toBeString substringToIndex:_limitNum];
            }
        }
        NSLog(@"%@",textView.text);
    }else {
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark - 键盘监听

- (void)keyboardWillShow:(NSNotification *)notification {
    //得到键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    // - 49
    self.frame = CGRectMake(0, _rect.origin.y - keyboardRect.size.height, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame));

    if ([self.delegate respondsToSelector:@selector(showKeyBoard)]) {
        [self.delegate showKeyBoard];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(hiddenKeyBoard)]) {
        [self.delegate hiddenKeyBoard];
    }
    //-49
    self.frame = _rect;
    
}

@end

//
//  HCModifyBindingMobileView.m
//  HongCai
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.



#import "HCModifyBindingMobileView.h"
#import "HCLoginTool.h"
#import "HCCaptchasApi.h"
#import "HCMobileCaptchaApi.h"
#import "NSBundle+HCLoginModule.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCModifyBindingMobileView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UILabel *bottomLine1;
@property (nonatomic, strong) UITextField *imageCodeTextField;
@property (nonatomic, strong) UILabel *bottomLine2;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UITextField *messageCodeTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UILabel *bottomLine3;
@property (nonatomic, strong) UIButton *nextButton;

@end


@implementation HCModifyBindingMobileView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.mobileTextField];
        [self addSubview:self.bottomLine1];
        [self addSubview:self.imageCodeTextField];
        [self addSubview:self.bottomLine2];
        [self addSubview:self.codeImageView];
        [self addSubview:self.messageCodeTextField];
        [self addSubview:self.codeButton];
        [self addSubview:self.bottomLine3];
        [self addSubview:self.nextButton];
        [self layout_Masonry];
    }
    return self;
}

- (void)layout_Masonry {
    
    
    CGFloat padding = 20.f;
    CGFloat textFieldHeight = 40.f;
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding);
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(textFieldHeight);
    }];
    
    [self.bottomLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.imageCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.width.mas_equalTo(self).multipliedBy(0.55);
        make.height.mas_equalTo(textFieldHeight);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).mas_offset(padding);
    }];
    [self.bottomLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageCodeTextField.mas_bottom);
        make.left.right.mas_equalTo(self.imageCodeTextField);
        make.height.mas_equalTo(0.5f);
    }];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageCodeTextField);
        make.right.mas_equalTo(-padding);
        make.left.mas_equalTo(self.imageCodeTextField.mas_right).mas_offset(21);
        make.height.mas_equalTo(textFieldHeight);
        
    }];
    [self.messageCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.width.mas_equalTo(self).multipliedBy(0.55);
        make.height.mas_equalTo(textFieldHeight);
        make.top.mas_equalTo(self.bottomLine2).mas_offset(15);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize size = [@"获取短信验证码" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        make.size.mas_equalTo(CGSizeMake(size.width+4, size.height+4));
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(self.messageCodeTextField);
    }];
    
    [self.bottomLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageCodeTextField.mas_bottom);
        make.left.mas_equalTo(self.messageCodeTextField);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageCodeTextField.mas_bottom).mas_offset(45.f);
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(self.nextButton.mas_width).multipliedBy(274.0/1442.0);
        
    }];
    
}

#pragma -mark events

- (void)nextButtonClick:(UIButton *)button {

    if (self.imageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入图形验证码！"];
        return;
    }
    if (self.messageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入短信验证码！"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(modifyBindingMobileView:nextButtonClick:)]) {
        [self.delegate modifyBindingMobileView:self nextButtonClick:button];
    }
}

-(void)codeButtonClick:(UIButton *)button {
    if (self.mobileTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入手机号！"];
        return;
    }
    
    if (![HCLoginTool isValidPhoneNum:self.mobileTextField.text]) {
        [MBProgressHUD showText:@"请输入正确的手机号！"];
        return;
    }
    if (self.imageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入图形验证码！"];
        return;
    }
    button.userInteractionEnabled = NO;
    [MBProgressHUD showLoadingFromView:self];
    HCMobileCaptchaApi * api = [[HCMobileCaptchaApi alloc] initWithBusiness:4 mobile:self.mobileTextField.text picCaptcha:self.imageCodeTextField.text type:0];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            if ([request.responseJSONObject[@"ret"] integerValue] ==1) {
                [self sendVerifyNum];
            }
            button.userInteractionEnabled = YES;
        }
        [MBProgressHUD hideHUDForView:self animated:NO];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        [MBProgressHUD hideHUDForView:self animated:NO];
        button.userInteractionEnabled = YES;

    }];
}
- (void)getCodeImage {
    HCCaptchasApi * api = [[HCCaptchasApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            NSDictionary * responseData = request.responseJSONObject;
            if (responseData) {
                NSData *decodedImageData   = [[NSData alloc] initWithBase64EncodedString:responseData[@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *decodedImage      = [UIImage imageWithData:decodedImageData];
                _codeImageView.image =decodedImage;
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (void)sendVerifyNum
{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.mobileTextField.text.length>11) {
        self.mobileTextField.text = [_mobileTextField.text substringToIndex:11];
    }else if (self.mobileTextField.text.length==11 &&self.imageCodeTextField.text.length>0 &&self.messageCodeTextField.text.length>0){
        self.nextButton.enabled = YES;
    }else{
        self.nextButton.enabled = NO;
    }
}

#pragma -mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.imageCodeTextField == textField ){
        self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }else if (self.messageCodeTextField == textField) {
        self.bottomLine3.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:[UILabel class]]&&subView.frame.size.height<1) {
            subView.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([HCLoginTool isContainChinese:string]) {
        return NO;
    }
    return YES;
}
#pragma -mark lazyLoadings

- (UITextField*)mobileTextField {
    if (!_mobileTextField){
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.borderStyle = UITextBorderStyleNone;
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _mobileTextField.attributedPlaceholder = placeholderText;
        _mobileTextField.font = [UIFont systemFontOfSize:15];
        _mobileTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _mobileTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _mobileTextField.delegate = self;
        _mobileTextField.enabled = NO;
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileTextField;
}
- (UILabel*)bottomLine1 {
    if (!_bottomLine1){
        _bottomLine1 = [[UILabel alloc] init];
        _bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine1;
}

- (UITextField*)imageCodeTextField {
    if (!_imageCodeTextField){
        _imageCodeTextField = [[UITextField alloc] init];
        _imageCodeTextField.borderStyle = UITextBorderStyleNone;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入图形验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _imageCodeTextField.attributedPlaceholder = placeholderText;
        _imageCodeTextField.font = [UIFont systemFontOfSize:15];
        _imageCodeTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _imageCodeTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _imageCodeTextField.delegate = self;
        _imageCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _imageCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _imageCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_imageCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _imageCodeTextField;
}
- (UIImageView*)codeImageView {
    if (!_codeImageView){
        _codeImageView = [[UIImageView alloc] init];
        _codeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCodeImage)];
        [_codeImageView addGestureRecognizer:tap];
        [self getCodeImage];
    }
    return _codeImageView;
}
- (UILabel*)bottomLine2 {
    if (!_bottomLine2){
        _bottomLine2 = [[UILabel alloc] init];
        _bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine2;
}


- (UITextField*)messageCodeTextField {
    if (!_messageCodeTextField){
        _messageCodeTextField = [[UITextField alloc] init];
        _messageCodeTextField.borderStyle = UITextBorderStyleNone;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _messageCodeTextField.attributedPlaceholder = placeholderText;
        _messageCodeTextField.font = [UIFont systemFontOfSize:15];
        _messageCodeTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _messageCodeTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _messageCodeTextField.delegate = self;
        _messageCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_messageCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _messageCodeTextField;
}
- (UIButton*)codeButton {
    if (!_codeButton){
        _codeButton = [[UIButton alloc] init];
        [_codeButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _codeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_codeButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(codeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}
- (UILabel*)bottomLine3 {
    if (!_bottomLine3){
        _bottomLine3 = [[UILabel alloc] init];
        _bottomLine3.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine3;
}

- (UIButton*)nextButton {
    if (!_nextButton){
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle login_ImageWithName:@"Registration_btn_nor"];
        _nextButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_nextButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage * disImage = [NSBundle login_ImageWithName:@"Registration_btn_dis"];
        _nextButton.enabled = NO;
        [_nextButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _nextButton;
}
@end

//
//  HCCodeLoginView.m
//  HongCai
//
//  Created by Candy on 2017/6/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCodeLoginView.h"
#import "HCLoginBottomView.h"
#import "HCCaptchasApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCMobileCaptchaApi.h"
#import "NSBundle+HCLoginModule.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCLoginTool.h"

@interface HCCodeLoginView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UITextField *imageCodeTextField;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UILabel *bottomLine1;
@property (nonatomic, strong) UITextField *messageCodeTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UILabel *bottomLine2;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) HCLoginBottomView *bottomView;
@end

@implementation HCCodeLoginView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconView];
        [self addSubview:self.imageCodeTextField];
        [self addSubview:self.codeImageView];
        [self addSubview:self.bottomLine1];
        [self addSubview:self.messageCodeTextField];
        [self addSubview:self.codeButton];
        [self addSubview:self.bottomLine2];
        [self addSubview:self.loginButton];
        [self addSubview:self.registerButton];
        [self addSubview:self.bottomView];
        [self layout_Masonry];

    }
    return self;
}
- (void)textFieldDidChange:(UITextField *)textField {
     if (self.imageCodeTextField.text.length>0 &&self.messageCodeTextField.text.length>0){
        self.loginButton.enabled = YES;
    }else{
        self.loginButton.enabled = NO;;
    }
}
- (void)layout_Masonry {
    
    CGFloat padding = 20.f;
    CGFloat textFieldHeight = 40.f;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        CGFloat imageScale = self.iconView.image.size.height/self.iconView.image.size.width;
        make.size.mas_equalTo(CGSizeMake(150, 150*imageScale));
        make.centerX.mas_equalTo(self);
    }];
    [self.imageCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.width.mas_equalTo(self).multipliedBy(0.55);
        make.height.mas_equalTo(textFieldHeight);
        make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(50.f);
    }];
    [self.bottomLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.mas_equalTo(self.bottomLine1).mas_offset(15);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize size = [@"获取短信验证码" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        make.size.mas_equalTo(CGSizeMake(size.width+4, size.height+4));
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(self.messageCodeTextField);
    }];
    
    [self.bottomLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageCodeTextField.mas_bottom);
        make.left.mas_equalTo(self.messageCodeTextField);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageCodeTextField.mas_bottom).mas_offset(45);
        make.left.mas_equalTo(self.imageCodeTextField);
        make.height.mas_equalTo(self.loginButton.mas_width).multipliedBy(274.0/1442.0);
        make.right.mas_equalTo(-padding);
    }];
   
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).mas_offset(5.f);
        make.centerX.mas_equalTo(self.loginButton);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(49*2);
    }];
    
}

#pragma -mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.imageCodeTextField==textField) {
        self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }else if (self.messageCodeTextField==textField ){
        self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.imageCodeTextField==textField) {
        self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }else if (self.messageCodeTextField==textField ){
        self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
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
#pragma -mark events
-(void)codeButtonClick:(UIButton *)button {
    
    if (self.imageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入图形验证码！"];
        return;
    }
    button.userInteractionEnabled = NO;
    HCMobileCaptchaApi * api = [[HCMobileCaptchaApi alloc] initWithBusiness:3 mobile:self.mobileNumber.stringValue picCaptcha:self.imageCodeTextField.text type:0];
    [MBProgressHUD showLoadingFromView:self];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (request.responseJSONObject) {
            if ([request.responseJSONObject[@"ret"] integerValue] ==1) {
                [self sendVerifyNum];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        button.userInteractionEnabled = YES;
    }];
}

- (void)loginButtonClick:(UIButton *)loginButton {
  
    if (self.messageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入短信验证码！"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(codeLoginView:loginButtonClick:)]) {
        [self.delegate codeLoginView:self loginButtonClick:loginButton];
    }
}
- (void)registerButtonClick:(UIButton *)registerButton {
    if ([self.delegate respondsToSelector:@selector(codeLoginView:registerButtonClick:)]) {
        [self.delegate codeLoginView:self registerButtonClick:registerButton];
    }
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
        [MBProgressHUD showText:request.error.localizedDescription];
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
#pragma -mark lazyLoadings

- (UIImageView*)iconView {
    if (!_iconView){
        _iconView = [[UIImageView alloc] initWithImage:[NSBundle login_ImageWithName:@"icon"]];
    }
    return _iconView;
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
        [_imageCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _imageCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _imageCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _imageCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
- (UILabel*)bottomLine1 {
    if (!_bottomLine1){
        _bottomLine1 = [[UILabel alloc] init];
        _bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine1;
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
        [_messageCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _messageCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
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
- (UILabel*)bottomLine2 {
    if (!_bottomLine2){
        _bottomLine2 = [[UILabel alloc] init];
        _bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine2;
}
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle login_ImageWithName:@"Registration_btn_nor"];
        [_loginButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage * disImage = [NSBundle login_ImageWithName:@"Registration_btn_dis"];
        _loginButton.enabled = NO;
        [_loginButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        _loginButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _loginButton;
}
- (UIButton*)registerButton {
    if (!_registerButton){
        _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_registerButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    return _registerButton;
}
- (HCLoginBottomView*)bottomView {
    if (!_bottomView){
        _bottomView = [HCLoginBottomView new];
    }
    return _bottomView;
}

@end


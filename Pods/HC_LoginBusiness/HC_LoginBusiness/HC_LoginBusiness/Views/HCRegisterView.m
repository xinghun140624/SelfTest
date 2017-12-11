//
//  HCRegisterView.m
//  HongCai
//
//  Created by Candy on 2017/6/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRegisterView.h"
#import "HCLoginBottomView.h"
#import "HCMobileCaptchaApi.h"
#import "HCCaptchasApi.h"
#import "HCLoginTool.h"
#import "NSBundle+HCLoginModule.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
@interface HCRegisterView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UITextField *mobileTextField;
@property (nonatomic, strong) UILabel *bottomLine1;
@property (nonatomic, strong) UITextField *imageCodeTextField;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UILabel *bottomLine2;
@property (nonatomic, strong) UITextField *messageCodeTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UILabel *bottomLine3;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *bottomLine4;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) UIButton *registerProtocolButton;
@property (nonatomic, strong) UIButton *gotoLoginButton;
@property (nonatomic, strong) UILabel * passwordStatusLabel;
@property (nonatomic, strong) HCLoginBottomView *bottomView;
@end


@implementation HCRegisterView

- (void)textFieldDidChange:(UITextField *)textField {
    
    self.passwordStatusLabel.hidden = !(self.passwordTextField.text.length>0);
    
    if (self.passwordTextField.text.length>15) {
        self.passwordTextField.text = [self.passwordTextField.text substringToIndex:16];
    }
    self.passwordStatusLabel.attributedText = [HCLoginTool checkPasswordLevel:self.passwordTextField.text];
    if (self.mobileTextField.text.length>11) {
        self.mobileTextField.text = [self.mobileTextField.text substringToIndex:11];
    }else if (_mobileTextField.text.length==11 &&self.imageCodeTextField.text.length>0&&self.messageCodeTextField.text.length>0&&self.passwordTextField.text.length>5){
        self.registerButton.enabled = YES;
    }else{
        self.registerButton.enabled = NO;;
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconView];
        [self addSubview:self.mobileTextField];
        [self addSubview:self.bottomLine1];
        [self addSubview:self.imageCodeTextField];
        [self addSubview:self.codeImageView];
        [self addSubview:self.bottomLine2];
        [self addSubview:self.messageCodeTextField];
        [self addSubview:self.codeButton];
        [self addSubview:self.bottomLine3];
        [self addSubview:self.passwordTextField];
        [self addSubview:self.passwordStatusLabel];
        [self addSubview:self.bottomLine4];
        [self addSubview:self.registerButton];
        [self addSubview:self.eyeButton];
        [self addSubview:self.registerProtocolButton];
        [self addSubview:self.gotoLoginButton];
        [self addSubview:self.bottomView];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([UIScreen mainScreen].bounds.size.height==480) {
            make.top.mas_equalTo(0);
        }else{
            make.top.mas_equalTo(15);
        }
        CGFloat imageW = self.iconView.image.size.height/self.iconView.image.size.width;
        make.size.mas_equalTo(CGSizeMake(303*0.5, 303*0.5*imageW));
        make.centerX.mas_equalTo(self);
    }];
    CGFloat padding = 20.f;
    CGFloat textFieldHeight = 40.f;
    if ([UIScreen mainScreen].bounds.size.height==480) {
        textFieldHeight = 30.f;
    }
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (CGRectGetWidth([UIScreen mainScreen].bounds)==320) {
            make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(25);
        }else{
            make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(50);
        }
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.bottomLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mobileTextField.mas_bottom);
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.imageCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.width.mas_equalTo(self).multipliedBy(0.55);
        make.height.mas_equalTo(textFieldHeight);
        make.top.mas_equalTo(self.bottomLine1.mas_bottom).mas_offset(10);
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
        make.top.mas_equalTo(self.bottomLine2).mas_offset(10);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        CGSize size = [@"获取短信验证码" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        make.size.mas_equalTo(CGSizeMake(size.width+4, size.height+4));
        make.centerY.mas_equalTo(self.messageCodeTextField);
    }];
    
    [self.bottomLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageCodeTextField.mas_bottom);
        make.left.right.mas_equalTo(self.messageCodeTextField);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomLine3).mas_offset(10);
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(textFieldHeight);
    }];
    
    [self.passwordStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.passwordTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_offset(5);
    }];
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.bottom.mas_equalTo(self.passwordTextField.mas_bottom);
    }];
    
    [self.bottomLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
        make.left.right.mas_equalTo(self.passwordTextField);
        make.height.mas_equalTo(0.5f);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomLine4.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(self.imageCodeTextField);
        make.height.mas_equalTo(self.registerButton.mas_width).multipliedBy(274.0/1442.0);
        make.right.mas_equalTo(-25.f);
    }];

    [self.registerProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerButton.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self);
    }];
    
    
    [self.gotoLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerProtocolButton.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(49);
    }];
}


#pragma -mark events
- (void)codeButtonClick:(UIButton *)button {
    if (self.mobileTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入手机号！"];
        return;
    }
    
    BOOL isPhoneNumber = [HCLoginTool isValidPhoneNum:self.mobileTextField.text];
    if (!isPhoneNumber) {
        [MBProgressHUD showText:@"请输入正确的手机号！"];
        return;
    }
    
    if (self.imageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入图形验证码！"];
        return;
    }
    button.userInteractionEnabled = NO;
    HCMobileCaptchaApi * api = [[HCMobileCaptchaApi alloc] initWithBusiness:0 mobile:self.mobileTextField.text picCaptcha:self.imageCodeTextField.text type:1];
    [MBProgressHUD showLoadingFromView:self];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (request.responseJSONObject) {
            if ([request.responseJSONObject[@"ret"] integerValue] ==1) {
                [self sendVerifyNum];
            }
            button.userInteractionEnabled = NO;
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
- (void)eyeButtonClick:(UIButton *)button {
    button.selected =!button.isSelected;
    NSString *tempPwdStr = self.passwordTextField.text;
    self.passwordTextField.text = @"";
    self.passwordTextField.secureTextEntry = !button.selected;
    self.passwordTextField.text = tempPwdStr;
}
- (void)registerButtonClick:(UIButton *)button {
    if (self.mobileTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入手机号！"];
        return;
    }
    BOOL isPhoneNumber = [HCLoginTool isValidPhoneNum:self.mobileTextField.text];
    if (!isPhoneNumber) {
        [MBProgressHUD showText:@"请输入正确的手机号！"];
        return;
    }
    if (self.imageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入图形验证码！"];
        return;
    }
    if (self.messageCodeTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入短信验证码！"];
        return;
    }
    if (self.passwordTextField.text.length==0) {
        [MBProgressHUD showText:@"请设置登录密码！"];
        return;
    }
    NSInteger result = [HCLoginTool checkPassword:self.passwordTextField.text];
    switch (result) {
        case 0:
        {
            [MBProgressHUD showText:@"登录密码由6-16位数字、字母组合而成，请重新设置!"];
            return;
        }
            break;
        case 1:
        {
            [MBProgressHUD showText:@"可输入的特殊字符有~!@#$%^&*请重新设置!"];
            return;
        }
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(registerView:registerButtonClick:)]) {
        [self.delegate registerView:self registerButtonClick:button];
    }
}

- (void)registerProtocolButtonClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(registerView:protocolButtonClick:)]) {
        [self.delegate registerView:self protocolButtonClick:button];
    }
    
}
- (void)gotoLoginButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(registerView:goLoginButtonClick:)]) {
        [self.delegate registerView:self goLoginButtonClick:button];
    }
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

#pragma -mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.mobileTextField == textField) {
        self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }else if (self.imageCodeTextField == textField ){
        self.bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }else if (self.messageCodeTextField == textField){
        self.bottomLine3.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
    }else if (self.passwordTextField == textField) {
        self.bottomLine4.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
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
- (UIImageView*)iconView {
    if (!_iconView){
        _iconView = [[UIImageView alloc] initWithImage:[NSBundle login_ImageWithName:@"icon"]];
    }
    return _iconView;
}
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
        _messageCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _messageCodeTextField.attributedPlaceholder = placeholderText;
        _messageCodeTextField.font = [UIFont systemFontOfSize:15];
        _messageCodeTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _messageCodeTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _messageCodeTextField.delegate = self;
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

- (UITextField*)passwordTextField {
    if (!_passwordTextField){
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.clearsOnBeginEditing = YES;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"密码由6-16位字母、数字组成" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _passwordTextField.attributedPlaceholder = placeholderText;
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        _passwordTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _passwordTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _passwordTextField.delegate = self;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _passwordTextField;
}
- (UIButton*)eyeButton {
    if (!_eyeButton){
        _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * norMalbackgroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_invisible_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectedBackgroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_visible_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_eyeButton setImage:norMalbackgroundImage forState:UIControlStateNormal];
        _eyeButton.adjustsImageWhenHighlighted = NO;
        _eyeButton.selected = YES;
        [_eyeButton setImage:selectedBackgroundImage forState:UIControlStateSelected];
        [_eyeButton addTarget:self action:@selector(eyeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
}
- (UILabel*)bottomLine4 {
    if (!_bottomLine4){
        _bottomLine4 = [[UILabel alloc] init];
        _bottomLine4.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine4;
}

- (UIButton*)registerButton {
    if (!_registerButton){
        _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        UIImage * backgroundImage = [NSBundle login_ImageWithName:@"Registration_btn_nor"];
        _registerButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_registerButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        UIImage * disImage = [NSBundle login_ImageWithName:@"Registration_btn_dis"];
        _registerButton.enabled = NO;
        [_registerButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _registerButton;
}

- (UIButton *)registerProtocolButton {
    if (!_registerProtocolButton){
        _registerProtocolButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSMutableAttributedString *agreeText = [[NSMutableAttributedString alloc] initWithString:@"注册即表示您同意"];
        [agreeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, agreeText.string.length)];
        [agreeText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x666666"] range:NSMakeRange(0, agreeText.string.length)];

        NSMutableAttributedString *protocolText = [[NSMutableAttributedString alloc] initWithString:@"《宏财网注册协议》" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        [protocolText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x006cff"] range:NSMakeRange(0, protocolText.string.length)];
        [agreeText appendAttributedString:protocolText];
        [_registerProtocolButton addTarget:self action:@selector(registerProtocolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_registerProtocolButton setAttributedTitle:agreeText forState:UIControlStateNormal];
    }
    return _registerProtocolButton;
}
- (UIButton *)gotoLoginButton {
    if (!_gotoLoginButton) {
        _gotoLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSMutableAttributedString *accountText = [[NSMutableAttributedString alloc] initWithString:@"已有账号，"];
        [accountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, accountText.string.length)];
        [accountText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x666666"] range:NSMakeRange(0, accountText.string.length)];
        NSMutableAttributedString *goLoginText = [[NSMutableAttributedString alloc] initWithString:@"去登录" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        [goLoginText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(0, goLoginText.string.length)];
        [goLoginText addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(0, goLoginText.string.length)];
        [goLoginText addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, goLoginText.string.length)];
        [accountText appendAttributedString:goLoginText];
        [_gotoLoginButton addTarget:self action:@selector(gotoLoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_gotoLoginButton setAttributedTitle:accountText forState:UIControlStateNormal];
    }
    return _gotoLoginButton;
}
- (UILabel *)passwordStatusLabel {
    if(!_passwordStatusLabel) {
        _passwordStatusLabel = [[UILabel alloc] init];
        _passwordStatusLabel.font = [UIFont systemFontOfSize:13];
    }
    return _passwordStatusLabel;
}

- (HCLoginBottomView*)bottomView {
    if (!_bottomView){
        _bottomView = [HCLoginBottomView new];
    }
    return _bottomView;
}
@end

//
//  HCPasswordLoginView.m
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCPasswordLoginView.h"
#import "HCLoginBottomView.h"
#import "NSBundle+HCLoginModule.h"
#import "HCLoginTool.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCPasswordLoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong, readwrite) UITextField *pwdTextField;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UILabel *seperatorLine;
@property (nonatomic, strong) UIButton *eyeButton;

@property (nonatomic, strong) UIButton *forgetPwdButton;
@property (nonatomic, strong) HCLoginBottomView *bottomView;

@end

@implementation HCPasswordLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.iconView];
        [self addSubview:self.pwdTextField];
        [self addSubview:self.eyeButton];
        [self addSubview:self.bottomLine];
        [self addSubview:self.loginButton];
        [self addSubview:self.registerButton];
        [self addSubview:self.seperatorLine];
        [self addSubview:self.forgetPwdButton];
        [self addSubview:self.bottomView];
        [self layout_Masonry];
    }
    return self;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length>15) {
        self.pwdTextField.text = [textField.text substringToIndex:16];
    }
    if (self.pwdTextField.text.length>5){
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
        CGFloat imageW = self.iconView.image.size.height/self.iconView.image.size.width;
        make.size.mas_equalTo(CGSizeMake(303*0.5, 303*0.5*imageW));
        make.centerX.mas_equalTo(self);
        
    }];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(textFieldHeight);
        make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(50.f);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdTextField.mas_bottom);
        make.left.right.mas_equalTo(self.pwdTextField);
        make.height.mas_equalTo(0.5f);
    }];
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(self.pwdTextField.mas_right);
        make.bottom.mas_equalTo(self.pwdTextField.mas_bottom);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdTextField.mas_bottom).mas_offset(45);
        make.left.mas_equalTo(self.pwdTextField);
        make.height.mas_equalTo(self.loginButton.mas_width).multipliedBy(274.0/1442.0);
        make.right.mas_equalTo(-padding);
    }];

    [self.seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).mas_offset(25);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(1.f);
        make.height.mas_equalTo(12.f);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.seperatorLine);
        make.right.mas_equalTo(self.seperatorLine).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.seperatorLine);
        make.left.mas_equalTo(self.seperatorLine).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(49*2);
    }];
}


#pragma -mark Events

- (void)eyeButtonClick:(UIButton *)button {
    button.selected =!button.isSelected;
    NSString *tempPwdStr = self.pwdTextField.text;
    self.pwdTextField.text = @"";
    self.pwdTextField.secureTextEntry = !button.selected;
    self.pwdTextField.text = tempPwdStr;
}
- (void)loginButtonClick:(UIButton*)button {
    
    if (self.pwdTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入登录密码！"];
        return;
    }
  
    if ([self.delegate respondsToSelector:@selector(passwordLoginView:loginButtonClick:)]) {
        [self.delegate passwordLoginView:self loginButtonClick:button];
    }
}

- (void)registerButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(passwordLoginView:registerButtonClick:)]) {
        [self.delegate passwordLoginView:self registerButtonClick:button];
    }
}
- (void)forgetPwdButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(passwordLoginView:forgetPwdButtonClick:)]) {
        [self.delegate passwordLoginView:self forgetPwdButtonClick:button];
    }
}


#pragma -mark UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor =[UIColor colorWithHexString:@"0xff6000"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([HCLoginTool isContainChinese:string]) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma -mark lazyLoadings
- (UIImageView*)iconView {
    if (!_iconView){
        _iconView = [[UIImageView alloc] initWithImage:[NSBundle login_ImageWithName:@"icon"]];
    }
    return _iconView;
}
- (UITextField*)pwdTextField {
    if (!_pwdTextField){
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.borderStyle = UITextBorderStyleNone;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _pwdTextField.attributedPlaceholder = placeholderText;
        _pwdTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _pwdTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _pwdTextField.font = [UIFont systemFontOfSize:15];
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _pwdTextField.clearsOnBeginEditing = YES;
        _pwdTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _pwdTextField.delegate = self;
    }
    return _pwdTextField;
}
- (UIView*)bottomLine {
    if (!_bottomLine){
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine;
}
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle login_ImageWithName:@"Registration_btn_nor"];
        [_loginButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage * disImage = [NSBundle login_ImageWithName:@"Registration_btn_dis"];
        _loginButton.enabled = NO;
        [_loginButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        _loginButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _loginButton;
}
- (UIButton*)eyeButton {
    if (!_eyeButton){
        _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * norMalbackgroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_invisible_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectedBackgroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_visible_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_eyeButton setImage:norMalbackgroundImage forState:UIControlStateNormal];
        _eyeButton.adjustsImageWhenHighlighted = NO;
        [_eyeButton setImage:selectedBackgroundImage forState:UIControlStateSelected];
        [_eyeButton addTarget:self action:@selector(eyeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
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
- (UIButton*)forgetPwdButton {
    if (!_forgetPwdButton){
        _forgetPwdButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetPwdButton addTarget:self action:@selector(forgetPwdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_forgetPwdButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [_forgetPwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    }
    return _forgetPwdButton;
}
- (UILabel*)seperatorLine {
    if (!_seperatorLine){
        _seperatorLine = [[UILabel alloc] init];
        _seperatorLine.backgroundColor = [UIColor colorWithHexString:@"0x666666"];
        _seperatorLine.font = [UIFont systemFontOfSize:20];
    }
    return _seperatorLine;
}
- (HCLoginBottomView*)bottomView {
    if (!_bottomView){
        _bottomView = [HCLoginBottomView new];
    }
    return _bottomView;
}
@end

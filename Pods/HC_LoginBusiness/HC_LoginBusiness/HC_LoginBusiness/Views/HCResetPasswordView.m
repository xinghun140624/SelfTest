//
//  HCResetPasswordView.m
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCResetPasswordView.h"
#import "HCLoginTool.h"
#import "NSBundle+HCLoginModule.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCResetPasswordView ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel * passwordStatusLabel;
@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong) UIButton * eyeButton;
@property (nonatomic, strong) UIButton *completeButton;
@end

@implementation HCResetPasswordView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.passwordTextField];
        [self addSubview:self.passwordStatusLabel];
        [self addSubview:self.bottomLine];
        [self addSubview:self.eyeButton];
        [self addSubview:self.completeButton];
        [self layout_Masonry];
    }
    return self;
}
- (void)textFieldDidChange:(UITextField *)textField {
    self.passwordStatusLabel.hidden = !(self.passwordTextField.text.length>0);
    if (self.passwordTextField.text.length>15) {
        self.passwordTextField.text = [self.passwordTextField.text substringToIndex:16];
    }
    self.passwordStatusLabel.attributedText = [HCLoginTool checkPasswordLevel:self.passwordTextField.text];
    self.completeButton.enabled = (self.passwordTextField.text.length>5);
}
-(void)layout_Masonry {

    CGFloat padding = 20.f;
    CGFloat textFieldHeight = 40.f;
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding);
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.passwordStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.passwordTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_offset(5);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordTextField);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.bottom.mas_equalTo(self.passwordTextField.mas_bottom);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_offset(45.f);
        make.left.right.mas_equalTo(self.passwordTextField);
        make.height.mas_equalTo(self.completeButton.mas_width).multipliedBy(274.0/1442.0);
        
    }];
    
}

#pragma -mark events
- (void)completeButtonClick:(UIButton *)button {
    if (self.passwordTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入新密码！"];
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
    if ([self.delegate respondsToSelector:@selector(resetPasswordView:completeButtonClick:)]) {
        [self.delegate resetPasswordView:self completeButtonClick:button];
    }
}

- (void)eyeButtonClick:(UIButton *)button {
    button.selected =!button.isSelected;
    NSString *tempPwdStr = self.passwordTextField.text;
    self.passwordTextField.text = @"";
    self.passwordTextField.secureTextEntry = !button.selected;
    self.passwordTextField.text = tempPwdStr;
}

#pragma -mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
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
#pragma  -lazyLoadings

- (UITextField*)passwordTextField {
    if (!_passwordTextField){
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"新密码由6-16位数字、字母组合而成" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _passwordTextField.attributedPlaceholder = placeholderText;
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        _passwordTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _passwordTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _passwordTextField.delegate = self;
        _passwordTextField.clearsOnBeginEditing = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}
- (UILabel*)bottomLine {
    if (!_bottomLine){
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine;
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

- (UIButton*)completeButton {
    if (!_completeButton){
        _completeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _completeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle login_ImageWithName:@"Registration_btn_nor"];
        _completeButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_completeButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage * disImage = [NSBundle login_ImageWithName:@"Registration_btn_dis"];
        _completeButton.enabled = NO;
        [_completeButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _completeButton;
}
- (UILabel *)passwordStatusLabel {
    if(!_passwordStatusLabel) {
        _passwordStatusLabel = [[UILabel alloc] init];
        _passwordStatusLabel.font = [UIFont systemFontOfSize:13];
    }
    return _passwordStatusLabel;
}

@end

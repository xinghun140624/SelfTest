//
//  HCLoginView.m
//  HongCai
//
//  Created by Candy on 2017/6/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCLoginView.h"
#import "HCLoginBottomView.h"
#import "HCLoginTool.h"
#import "NSBundle+HCLoginModule.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCLoginView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong, readwrite) UITextField *mobileTextField;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) HCLoginBottomView *bottomView;
@end

@implementation HCLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconView];
        [self addSubview:self.mobileTextField];
        [self addSubview:self.bottomLine];
        [self addSubview:self.nextButton];
        [self addSubview:self.registerButton];
        [self addSubview:self.bottomView];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        CGFloat imageScale = self.iconView.image.size.height/self.iconView.image.size.width;
        make.size.mas_equalTo(CGSizeMake(150, 150*imageScale));
        make.centerX.mas_equalTo(self);
    }];
    CGFloat padding = 20.f;
    CGFloat textFieldHeight = 40.f;
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(87.5);
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(0.5f);
    }];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(textFieldHeight);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).mas_offset(0);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).mas_offset(40.f);
        make.left.right.mas_equalTo(self.mobileTextField);
        make.height.mas_equalTo(self.nextButton.mas_width).multipliedBy(274.0/1442.0);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nextButton.mas_bottom).mas_offset(0.f);
        make.centerX.mas_equalTo(self.nextButton);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(49*2);
    }];
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length>11) {
        textField.text = [textField.text substringToIndex:11];
    }
    self.nextButton.enabled = textField.text.length==11;
}

#pragma -mark functions
- (void)nextButtonClick:(UIButton *)button {
    if (![HCLoginTool isValidPhoneNum:self.mobileTextField.text]) {
        [MBProgressHUD showText:@"请输入正确的手机号！"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(loginView:nextButtonClick:)]) {
        [self.delegate loginView:self nextButtonClick:button];
    }
}

- (void)registerButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(loginView:registerButtonClick:)]) {
        [self.delegate loginView:self registerButtonClick:button];
    }
}

#pragma -mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor =[UIColor colorWithHexString:@"0xff6000"];
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
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _mobileTextField.font = [UIFont systemFontOfSize:15];
        _mobileTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _mobileTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _mobileTextField.delegate = self;
    }
    return _mobileTextField;
}
- (UIView*)bottomLine {
    if (!_bottomLine){
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine;
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
- (HCLoginBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [HCLoginBottomView new];
    }
    return _bottomView;
}
@end

//
//  HCRecommendedSetPasswordView.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/7/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRecommendedSetPasswordView.h"
#import "HCLoginTool.h"
#import "NSBundle+HCLoginModule.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCRecommandSetLoginPasswordApi.h"
#import "HCLoginTool.h"
#import "HCLoginBusinessNotificationName.h"
#import <HC_GestureBusiness/HCSettingGestureService.h>
@interface HCRecommendedSetPasswordView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIView * topContentView;
@property (nonatomic, strong) UIButton * eyeButton;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *bottomLine1;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UILabel * passwordStatusLabel;

@end

@implementation HCRecommendedSetPasswordView

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topContentView = [UIView new];
        self.topContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topContentView];
        [self.topContentView addSubview:self.iconView];
        [self.topContentView addSubview:self.descLabel];
        [self addSubview:self.passwordTextField];
        [self addSubview:self.passwordStatusLabel];
        [self addSubview:self.eyeButton];
        [self addSubview:self.bottomLine1];
        [self addSubview:self.completeButton];
        
        [self layout_Masonry];
    }
    return self;
}
-(void)layout_Masonry {
    
    CGFloat padding = 20.f;
    CGFloat textFieldHeight = 40.f;
    
    [self.topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30.f);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.mas_equalTo(0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.iconView);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContentView.mas_bottom).mas_offset(40.f);
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
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
    [self.bottomLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.passwordTextField);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
    
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_offset(45.f);
        make.left.right.mas_equalTo(self.passwordTextField);
        make.height.mas_equalTo(self.completeButton.mas_width).multipliedBy(274.0/1442.0);
        
    }];
    
}
- (void)textFieldDidChange:(UITextField *)textField {
    self.passwordStatusLabel.hidden = !(self.passwordTextField.text.length>0);
    if (self.passwordTextField.text.length>15) {
        self.passwordTextField.text = [self.passwordTextField.text substringToIndex:16];
    }
    self.passwordStatusLabel.attributedText = [HCLoginTool checkPasswordLevel:self.passwordTextField.text];

    if (self.passwordTextField.text.length >5) {
        self.completeButton.enabled = YES;
    }else{
        self.completeButton.enabled = NO;
    }
}

#pragma -mark events
- (void)completeButtonClick:(UIButton *)button {
    if (self.passwordTextField.text.length==0) {
        [MBProgressHUD showText:@"请输入密码！"];
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
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSString * password = [HCLoginTool stringToMD5:self.passwordTextField.text];
    HCRecommandSetLoginPasswordApi * api = [[HCRecommandSetLoginPasswordApi alloc] initWithToken:user[@"token"] password:password];
    [MBProgressHUD showLoadingFromView:self];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSMutableDictionary * myuser = [request.responseJSONObject mutableCopy];
        myuser[@"originMobile"] = user[@"originMobile"];
        BOOL success =  [[CTMediator sharedInstance] HCUserBusiness_saveUser:myuser];
        if (success) {
            [[self getCurrentViewController].navigationController dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                [HCSettingGestureService checkUserIsAppearReconmandSettingGesturePassword];
            }];
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
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
    self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xff6000"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
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
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[NSBundle login_ImageWithName:@"hcbb"]];
    }
    return _iconView;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:15];
        NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 5.f;
        NSMutableAttributedString * desc = [[NSMutableAttributedString alloc] initWithString:@"您还没有设置登录密码哦！\n快来设置吧！"];
        [desc addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, desc.string.length)];
        _descLabel.attributedText = desc;
        _descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _descLabel;
}
- (UITextField*)passwordTextField {
    if (!_passwordTextField){
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入6-16位数字、字母组合密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
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
- (UILabel*)bottomLine1 {
    if (!_bottomLine1){
        _bottomLine1 = [[UILabel alloc] init];
        _bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _bottomLine1;
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

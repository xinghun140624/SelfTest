//
//  HCForgetPassWordController.m
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCForgetPassWordController.h"
#import "HCForgetPassWordView.h"
#import "HCResetPasswordController.h"
#import "HCMobileCheckApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

@interface HCForgetPassWordController ()<HCForgetPassWordViewDelegate>
@property (nonatomic, strong) HCForgetPassWordView *forgetPasswordView;
@end

@implementation HCForgetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"忘记密码" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.forgetPasswordView];
    [self.forgetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"0xff611d"]] forBarMetrics:UIBarMetricsDefault];
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma -mark HCForgetPasswordViewDelegate
- (void)forgetPasswordView:(HCForgetPassWordView *)forgetPasswordView nextButtonClick:(UIButton *)button {
    HCMobileCheckApi * api = [[HCMobileCheckApi alloc] initWithBusiness:1 mobile:forgetPasswordView.mobileTextField.text captcha:forgetPasswordView.messageCodeTextField.text type:0];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        HCResetPasswordController * resetPasswordVC = [[HCResetPasswordController alloc] init];
        resetPasswordVC.mobileNumber = forgetPasswordView.mobileTextField.text;
        resetPasswordVC.messageCode = forgetPasswordView.messageCodeTextField.text;
        [self.navigationController pushViewController:resetPasswordVC animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
}
- (HCForgetPassWordView*)forgetPasswordView {
    if (!_forgetPasswordView){
        _forgetPasswordView = [[HCForgetPassWordView alloc] initWithFrame:CGRectZero];
        _forgetPasswordView.delegate = self;
        _forgetPasswordView.mobileTextField.text = self.mobileAccount;
    }
    return _forgetPasswordView;
}

- (void)closeButtonClick:(UIButton *)closeButton {
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}
- (void)backButtonClick:(UIButton *)backButton {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

//
//  HCResetPasswordController.m
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCResetPasswordController.h"
#import "HCResetPasswordView.h"
#import "HCResetMobilePasswordApi.h"
#import "HCLoginTool.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCLoginBusinessNotificationName.h"
#import <HC_GestureBusiness/HCSettingGestureService.h>
@interface HCResetPasswordController ()<HCResetPasswordViewDelegate>
@property (nonatomic, strong) HCResetPasswordView *resetPasswordView;

@end

@implementation HCResetPasswordController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"0xff611d"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"重置密码" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    [self.view addSubview:self.resetPasswordView];
    [self.resetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)resetPasswordView:(HCResetPasswordView *)resetPasswordView completeButtonClick:(UIButton *)button {
    NSString * password = [HCLoginTool stringToMD5:resetPasswordView.passwordTextField.text];
    HCResetMobilePasswordApi * api = [[HCResetMobilePasswordApi alloc] initWithBusiness:1 mobile:self.mobileNumber captcha:self.messageCode password:password];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:@"重置密码成功"];
            NSMutableDictionary * user = [request.responseJSONObject mutableCopy];
            user[@"originMobile"]  = self.mobileNumber;
            BOOL success =  [[CTMediator sharedInstance] HCUserBusiness_saveUser:user];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HC_LoginSuccessNotification object:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                    [HCSettingGestureService checkUserIsAppearReconmandSettingGesturePassword];
                }];;
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
            
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
            
        }
    }];
    
}


- (HCResetPasswordView*)resetPasswordView {
    if (!_resetPasswordView){
        _resetPasswordView = [[HCResetPasswordView alloc] initWithFrame:CGRectZero];
        _resetPasswordView.delegate = self;
    }
    return _resetPasswordView;
}
@end

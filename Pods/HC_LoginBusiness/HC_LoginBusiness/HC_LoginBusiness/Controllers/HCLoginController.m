//
//  HCLoginController.m
//  HongCai
//
//  Created by Candy on 2017/6/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCLoginController.h"
#import "HCLoginView.h"
#import <Masonry/Masonry.h>
#import "HCCodeLoginController.h"
#import "HCPasswordLoginController.h"
#import "HCRegisterController.h"
#import "NSBundle+HCLoginModule.h"
#import "HCUserHadPasswordApi.h"
#import "HCUserIsUniqueApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCLoginBusinessNotificationName.h"
@interface HCLoginController ()<HCLoginViewDelegate>
@property (nonatomic, strong) HCLoginView *loginView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation HCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.loginView.mobileTextField.isFirstResponder) {
        [self.loginView.mobileTextField resignFirstResponder];
    }
}
- (void)dealloc {
#if DEBUG
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
#endif
}

#pragma -mark events
- (void)closeButtonClick:(UIButton *)button {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HCLoginBusinessCloseClickNotification object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma -mark Requests 
- (void)checkAccountisUnique:(void(^)(BOOL isUnique))isUnique {
    HCUserIsUniqueApi * api = [[HCUserIsUniqueApi alloc] initWithAccount:self.loginView.mobileTextField.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showText:@"手机号还没有注册，请先去注册哦~"];
        if (isUnique) {
            isUnique(NO);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject && [request.responseObject[@"code"] integerValue]==-1099) {
            if (isUnique) {
                isUnique(YES);
            }
        }else if( [request.responseObject[@"ret"] integerValue]==-1){
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
            
        }
    }];
}
- (void)checkIsHadPassword:(void(^)(BOOL isHad))isHad {
    HCUserHadPasswordApi * api = [[HCUserHadPasswordApi alloc] initWithMobile:self.loginView.mobileTextField.text];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            if ([request.responseJSONObject[@"status"] integerValue]==1) {
                if (isHad) {
                    isHad(YES);
                }
            }else{
                if (isHad) {
                    isHad(NO);
                }
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
#pragma -mark HCLoginViewDelegate
- (void)loginView:(HCLoginView *)loginView registerButtonClick:(UIButton *)button {
    HCRegisterController *registerVC = [[HCRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)loginView:(HCLoginView *)loginView nextButtonClick:(UIButton *)button {
    [MBProgressHUD showLoadingFromView:self.view];
    [self checkAccountisUnique:^(BOOL isUnique) {
        if (isUnique) {
            [self checkIsHadPassword:^(BOOL isHad) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (isHad) {
                    //密码登录
                    HCPasswordLoginController * passwordLoginVC = [[HCPasswordLoginController alloc] init];
                    passwordLoginVC.mobileNumber = loginView.mobileTextField.text;
                    [self.navigationController pushViewController:passwordLoginVC animated:YES];
                }else{
                    //验证码登录
                    HCCodeLoginController * codeLoginVC = [[HCCodeLoginController alloc] init];
                    codeLoginVC.mobileNumber = @(loginView.mobileTextField.text.integerValue);
                    [self.navigationController pushViewController:codeLoginVC animated:YES];
                }
            }];
        }
    }];
}

#pragma -mark lazyLoadings;

- (HCLoginView*)loginView {
    if (!_loginView){
        _loginView = [[HCLoginView alloc] initWithFrame:CGRectZero];
        _loginView.delegate = self;
    }
    return _loginView;
}
- (UIButton*)closeButton {
    if (!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * backGroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_close_Dark_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_closeButton setImage:backGroundImage forState:UIControlStateNormal];
        _closeButton.frame = CGRectMake(0, 0, 50, 40);
    }
    return _closeButton;
}


@end


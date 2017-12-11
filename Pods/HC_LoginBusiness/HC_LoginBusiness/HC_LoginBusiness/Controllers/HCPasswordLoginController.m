//
//  HCPasswordLoginController.m
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCPasswordLoginController.h"
#import "HCPasswordLoginView.h"
#import "HCRegisterController.h"
#import "HCForgetPassWordController.h"
#import "HCPasswordLoginApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCLoginTool.h"
#import "NSBundle+HCLoginModule.h"
#import <Masonry/Masonry.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCLoginBusinessNotificationName.h"
#import <HC_GestureBusiness/HCSettingGestureService.h>
@interface HCPasswordLoginController ()<HCPasswordLoginViewDelegate>
@property (nonatomic, strong) HCPasswordLoginView *pwdLoginView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation HCPasswordLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pwdLoginView];
    [self.pwdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
}

#pragma -mark events

- (void)backButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)closeButtonClick:(UIButton *)closeButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:HCLoginBusinessCloseClickNotification object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}



#pragma  -mark HCPasswordLoginViewDelegate
- (void)passwordLoginView:(HCPasswordLoginView *)loginView loginButtonClick:(UIButton *)button {

    NSString * password = [HCLoginTool stringToMD5:loginView.pwdTextField.text];
    HCPasswordLoginApi * api = [[HCPasswordLoginApi alloc] initWithAccount:self.mobileNumber password:password];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ( request.responseJSONObject) {
            NSMutableDictionary * user = [request.responseJSONObject mutableCopy];
            user[@"originMobile"]  = self.mobileNumber;
            BOOL success = [[CTMediator sharedInstance] HCUserBusiness_saveUser:user];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HC_LoginSuccessNotification object:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                    [HCSettingGestureService checkUserIsAppearReconmandSettingGesturePassword];
                }];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (void)passwordLoginView:(HCPasswordLoginView *)loginView registerButtonClick:(UIButton *)button{
    HCRegisterController * registerVC = [[HCRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (void)passwordLoginView:(HCPasswordLoginView *)loginView forgetPwdButtonClick:(UIButton *)button {
    HCForgetPassWordController *forgetPassWordVC = [[HCForgetPassWordController alloc] init];
    forgetPassWordVC.mobileAccount = self.mobileNumber;
    if ([self.pwdLoginView.pwdTextField isFirstResponder]) {
        [self.pwdLoginView.pwdTextField resignFirstResponder];
    }
    [self.navigationController pushViewController:forgetPassWordVC animated:YES];
}

#pragma -mark lazyLoadings

- (HCPasswordLoginView*)pwdLoginView {
    if (!_pwdLoginView){
        _pwdLoginView = [[HCPasswordLoginView alloc] initWithFrame:CGRectZero];
        _pwdLoginView.delegate = self;
    }
    return _pwdLoginView;
}

- (UIButton*)backButton {
    if (!_backButton){
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * backGroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_return_Dark_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:backGroundImage forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(0, 0, 40, 40);
    }
    return _backButton;
}
- (UIButton*)closeButton {
    if (!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * backGroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_close_Dark_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:backGroundImage forState:UIControlStateNormal];
        _closeButton.frame = CGRectMake(0, 0, 50, 40);
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _closeButton;
}
@end

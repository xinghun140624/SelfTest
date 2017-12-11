//
//  HCRegisterController.m
//  HongCai
//
//  Created by Candy on 2017/6/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRegisterController.h"
#import "HCRegisterView.h"
#import "HCLoginTool.h"
#import "HCRegisterApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "NSBundle+HCLoginModule.h"
#import <Masonry/Masonry.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCLoginBusinessNotificationName.h"
#import <HC_GestureBusiness/HCSettingGestureService.h>
@interface HCRegisterController ()<HCRegisterViewDelegate>
@property (nonatomic, strong) HCRegisterView *registerView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation HCRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.registerView];
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
#pragma -mark HCRegisterViewDelegate

- (void)registerView:(HCRegisterView *)registerView registerButtonClick:(UIButton *)button {
    NSString * mobile = registerView.mobileTextField.text;
    NSString * captcha = registerView.messageCodeTextField.text;
    NSString * password = [HCLoginTool stringToMD5:registerView.passwordTextField.text];
    HCRegisterApi * api = [[HCRegisterApi alloc] initWithMobile:mobile captcha:captcha password:password];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ( request.responseJSONObject) {
            NSMutableDictionary * user = [request.responseJSONObject mutableCopy];
            user[@"originMobile"]  = registerView.mobileTextField.text;
            BOOL success = [[CTMediator sharedInstance] HCUserBusiness_saveUser:user];
            if (success) {
                [MBProgressHUD showText:@"登录成功~"];
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
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (void)registerView:(HCRegisterView *)registerView protocolButtonClick:(id )view {
    NSString * url = @"http://app.hongcai.com/register-agree";
    UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url,HCWebBusinessNavigationType:@(2)}];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:NULL];
}
- (void)registerView:(HCRegisterView *)registerView goLoginButtonClick:(id)view {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma -mark events
- (void)closeButtonClick:(UIButton *)closeButton {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HCLoginBusinessCloseClickNotification object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma -mark lazyLoadings

- (HCRegisterView*)registerView {
    if (!_registerView){
        _registerView = [[HCRegisterView alloc] initWithFrame:CGRectZero];
        _registerView.delegate = self;
    }
    return _registerView;
}
- (UIButton*)closeButton {
    if (!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * backGroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_close_Dark_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:backGroundImage forState:UIControlStateNormal];
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _closeButton.frame = CGRectMake(0, 0, 50, 40);
    }
    return _closeButton;
}
@end

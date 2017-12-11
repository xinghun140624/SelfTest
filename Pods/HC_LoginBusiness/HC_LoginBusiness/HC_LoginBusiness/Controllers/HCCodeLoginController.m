//
//  HCCodeLoginController.m
//  HongCai
//
//  Created by Candy on 2017/6/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCodeLoginController.h"
#import "HCCodeLoginView.h"
#import "HCRegisterController.h"
#import "HCCodeLoginApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "NSBundle+HCLoginModule.h"
#import "HCRecommandedSetPasswordController.h"
#import "HCLoginBusinessNotificationName.h"
#import <Masonry/Masonry.h>
@interface HCCodeLoginController ()<HCCodeLoginViewDelegate>
@property (nonatomic, strong) HCCodeLoginView *codeLoginView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation HCCodeLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.codeLoginView];
    [self.codeLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
}
- (void)closeButtonClick:(UIButton *)closeButton {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HCLoginBusinessCloseClickNotification object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma -mark HCCodeLoginViewDelegate
- (void)codeLoginView:(HCCodeLoginView *)loginView loginButtonClick:(UIButton *)button {
    HCCodeLoginApi * api = [[HCCodeLoginApi alloc] initWithMobile:self.mobileNumber.stringValue captcha:loginView.messageCodeTextField.text];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            NSMutableDictionary * user = [request.responseJSONObject mutableCopy];
            user[@"originMobile"]  = self.mobileNumber;
            BOOL success = [[CTMediator sharedInstance] HCUserBusiness_saveUser:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:HC_LoginSuccessNotification object:nil];
            if (success) {
                UIViewController * controller = [[HCRecommandedSetPasswordController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
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

- (void)codeLoginView:(HCCodeLoginView *)loginView registerButtonClick:(UIButton *)button {
    HCRegisterController * registerVC =[[HCRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma -mark lazyLoadings

- (HCCodeLoginView*)codeLoginView {
    if (!_codeLoginView){
        _codeLoginView = [[HCCodeLoginView alloc] initWithFrame:CGRectZero];
        _codeLoginView.delegate = self;
        _codeLoginView.mobileNumber = self.mobileNumber;
    }
    return _codeLoginView;
}

- (UIButton*)closeButton {
    if (!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * backGroundImage = [[NSBundle login_ImageWithName:@"Registration_icon_close_Dark_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:backGroundImage forState:UIControlStateNormal];
        _closeButton.frame = CGRectMake(0, 0, 50, 40);
    }
    return _closeButton;
}

@end

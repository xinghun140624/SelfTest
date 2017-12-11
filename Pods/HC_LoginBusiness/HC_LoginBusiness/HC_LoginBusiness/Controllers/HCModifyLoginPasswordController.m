//
//  HCModifyLoginPasswordController.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCModifyLoginPasswordController.h"
#import "HCModifyLoginPasswordView.h"
#import "HCModifyPasswordApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCLoginTool.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <Masonry/Masonry.h>
@interface HCModifyLoginPasswordController ()<HCModifyLoginPasswordViewDelegate>
@property (nonatomic, strong) HCModifyLoginPasswordView *modifyLoginPasswordView;
@end

@implementation HCModifyLoginPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"修改密码" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.modifyLoginPasswordView];
    [self.modifyLoginPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
- (void)modifyLoginPasswordView:(HCModifyLoginPasswordView *)view completeButtonClick:(UIButton *)button {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSString * token = user[@"token"];
    NSString * oldPassword = [HCLoginTool stringToMD5:view.originalPasswordTextField.text];
    NSString * newPassword = [HCLoginTool stringToMD5:view.passwordTextField.text];

    HCModifyPasswordApi * api = [[HCModifyPasswordApi alloc] initWithOldPassword:oldPassword newPassword:newPassword token:token];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showText:@"密码修改成功~"];
        NSMutableDictionary * myuser = [request.responseJSONObject mutableCopy];
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        myuser[@"originMobile"] = user[@"originMobile"];
        BOOL success =  [[CTMediator sharedInstance] HCUserBusiness_saveUser:myuser];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
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
- (HCModifyLoginPasswordView *)modifyLoginPasswordView {
    if (!_modifyLoginPasswordView) {
        _modifyLoginPasswordView = [[HCModifyLoginPasswordView alloc] initWithFrame:CGRectZero];
        _modifyLoginPasswordView.delegate = self;
    }
    return _modifyLoginPasswordView;
}
@end

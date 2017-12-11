//
//  HCModifyBindingMobileController.m
//  HongCai
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCModifyBindingMobileController.h"
#import "HCModifyBindingMobileView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCMobileCheckApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>

#import "HCBindingNewMobileController.h"

@interface HCModifyBindingMobileController ()<HCModifyBindingMobileViewDelegate>
@property (nonatomic, strong) HCModifyBindingMobileView *modifyBindingMobileView;

@end

@implementation HCModifyBindingMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"更改绑定手机号" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.modifyBindingMobileView];
    [self.modifyBindingMobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
}
- (void)modifyBindingMobileView:(HCModifyBindingMobileView *)view nextButtonClick:(UIButton *)button {
    HCMobileCheckApi * api = [[HCMobileCheckApi alloc] initWithBusiness:4 mobile:view.mobileTextField.text captcha:view.messageCodeTextField.text type:0];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        HCBindingNewMobileController * resetPasswordVC = [[HCBindingNewMobileController alloc] init];
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
- (HCModifyBindingMobileView *)modifyBindingMobileView {
    if (!_modifyBindingMobileView) {
        _modifyBindingMobileView = [[HCModifyBindingMobileView alloc] initWithFrame:CGRectZero];
        _modifyBindingMobileView.delegate = self;
        
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        
        _modifyBindingMobileView.mobileTextField.text = user[@"originMobile"];
        
    }
    return _modifyBindingMobileView;
}
@end

//
//  HCBindingNewMobileController.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCBindingNewMobileController.h"
#import "HCBindingNewMobileView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCResetMobileApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>

@interface HCBindingNewMobileController ()<HCBindingNewMobileViewDelegate>
@property (nonatomic, strong) HCBindingNewMobileView *bindingNewMobileView;
@end

@implementation HCBindingNewMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"绑定新手机号" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bindingNewMobileView];
    [self.bindingNewMobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
- (void)bindingNewMobileView:(HCBindingNewMobileView *)view bindingButtonClick:(UIButton *)button {
    HCResetMobileApi * api = [[HCResetMobileApi alloc] initWithMobile:view.mobileTextField.text captcha:view.messageCodeTextField.text];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            NSMutableDictionary * user = [request.responseJSONObject mutableCopy];
            user[@"originMobile"]  = self.bindingNewMobileView.mobileTextField.text;
            BOOL success = [[CTMediator sharedInstance] HCUserBusiness_saveUser:user];
            [MBProgressHUD showText:@"更改手机号成功~"];
            if (success) {
                if (self.navigationController) {
                    //跳转到设置页;
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }
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
- (HCBindingNewMobileView *)bindingNewMobileView {
    if (!_bindingNewMobileView) {
        _bindingNewMobileView = [[HCBindingNewMobileView alloc] initWithFrame:CGRectZero];
        _bindingNewMobileView.delegate = self;
    }
    return _bindingNewMobileView;
}
@end

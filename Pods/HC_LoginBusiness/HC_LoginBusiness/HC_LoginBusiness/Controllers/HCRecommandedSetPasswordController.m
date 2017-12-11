//
//  HCRecommandedSetPasswordController.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/7/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRecommandedSetPasswordController.h"
#import "HCRecommendedSetPasswordView.h"
#import "HCLoginBusinessNotificationName.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <HC_GestureBusiness/HCSettingGestureService.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <Masonry/Masonry.h>
@interface HCRecommandedSetPasswordController ()
@property (nonatomic, strong)HCRecommendedSetPasswordView *recommandSetPasswordView;
@end

@implementation HCRecommandedSetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"登录密码" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.view addSubview:self.recommandSetPasswordView];
    [self.recommandSetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 30);
    [button addTarget:self action:@selector(nextBarClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)nextBarClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [HCSettingGestureService checkUserIsAppearReconmandSettingGesturePassword];
    }];
}
- (HCRecommendedSetPasswordView *)recommandSetPasswordView {
    if (!_recommandSetPasswordView) {
        _recommandSetPasswordView = [[HCRecommendedSetPasswordView alloc] initWithFrame:CGRectZero];
    }
    return _recommandSetPasswordView;
}

@end

//
//  HCSettingLoginPasswordController.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSettingLoginPasswordController.h"
#import "HCSettingLoginPasswordView.h"
#import <Masonry/Masonry.h>
@interface HCSettingLoginPasswordController ()
@property (nonatomic, strong) HCSettingLoginPasswordView *settingLoginPasswordView;

@end

@implementation HCSettingLoginPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"设置登录密码" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.settingLoginPasswordView];
    [self.settingLoginPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (HCSettingLoginPasswordView *)settingLoginPasswordView {
    if (!_settingLoginPasswordView) {
        _settingLoginPasswordView = [[HCSettingLoginPasswordView alloc] initWithFrame:CGRectZero];
    }
    return _settingLoginPasswordView;
}
@end

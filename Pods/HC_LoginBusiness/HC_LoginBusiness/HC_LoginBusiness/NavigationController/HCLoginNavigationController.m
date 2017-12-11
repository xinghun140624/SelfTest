//
//  HCLoginNavigationController.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCLoginNavigationController.h"
#import "NSBundle+HCLoginModule.h"
@implementation HCLoginNavigationController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count>=1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setImage:[NSBundle login_ImageWithName:@"Registration_icon_return_Dark_nor"] forState:UIControlStateNormal];
        
        // 让按钮的内容往左边偏移10
        // 让按钮的内容往左边偏移10
        button.frame  = CGRectMake(0, 0, 60, 40);
        button.imageEdgeInsets = UIEdgeInsetsMake(0,-15, 0,0);

        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(popLastViewController) forControlEvents:UIControlEventTouchUpInside];
        UIView *backBtnView = [[UIView alloc] initWithFrame:button.bounds];
        [backBtnView addSubview:button];
        viewController.navigationItem.leftBarButtonItems = nil;
        UIBarButtonItem * space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = -16;
        
        viewController.navigationItem.leftBarButtonItems = @[space, [[UIBarButtonItem alloc] initWithCustomView:backBtnView]];

        
        if ([viewController isKindOfClass:[NSClassFromString(@"HCForgetPassWordController") class]]||[viewController isKindOfClass:[NSClassFromString(@"HCResetPasswordController") class]]) {
            
            [button setImage:[NSBundle login_ImageWithName:@"Registration_icon_return_White_nor"] forState:UIControlStateNormal];

        }
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        if ([viewController isKindOfClass:[NSClassFromString(@"HCRecommandedSetPasswordController") class]]||[viewController isKindOfClass:[NSClassFromString(@"HCRegisterController") class]]) {
            viewController.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:[UIButton new]]];
            self.interactivePopGestureRecognizer.enabled = NO;
        }
        
    }
    [super pushViewController:viewController animated:animated];
}
- (void)popLastViewController {
    [self popViewControllerAnimated:YES];
}

@end

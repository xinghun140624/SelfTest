//
//  Target_HCLoginBusiness.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCLoginBusiness.h"
#import "HCLoginController.h"
#import "HCModifyBindingMobileController.h"
#import "HCBindingNewMobileController.h"
#import "HCSettingLoginPasswordController.h"
#import "HCModifyLoginPasswordController.h"
#import "HCLoginNavigationController.h"
typedef void(^closeButtonClickCallBack)(void);

@implementation Target_HCLoginBusiness
- (UIViewController *)Action_viewController:(NSDictionary *)params {
    HCLoginController * viewController = [[HCLoginController alloc] init];
    viewController.closeButtonCallBack = ^{
        closeButtonClickCallBack callBack = params[@"closeButtonClickCallBack"];
        if (callBack) {
            callBack();
        }
    };
    HCLoginNavigationController * navigationVC = [[HCLoginNavigationController alloc] initWithRootViewController:viewController];
    return navigationVC;
}

- (UIViewController *)Action_modifyBingdingMobileViewController:(NSDictionary *)params {
    HCModifyBindingMobileController * viewController = [[HCModifyBindingMobileController alloc] init];
    return viewController;
}
- (UIViewController *)Action_bindingNewMobileViewController:(NSDictionary *)params {
    HCBindingNewMobileController * viewController = [[HCBindingNewMobileController alloc] init];
    return viewController;
}
- (UIViewController *)Action_settingLoginPasswordController:(NSDictionary *)params {
    HCSettingLoginPasswordController * viewController = [[HCSettingLoginPasswordController alloc] init];
    return viewController;
}
- (UIViewController *)Action_modifyLoginPasswordController:(NSDictionary *)params {
    HCModifyLoginPasswordController * viewController = [[HCModifyLoginPasswordController alloc] init];
    return viewController;
}

@end

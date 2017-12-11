//
//  HCRouterUrlService.m
//  HongCai
//
//  Created by 郭金山 on 2017/11/13.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRouterUrlService.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCInvestWebController.h"
#import "HCMemberCenterController.h"
#import "HCNetworkConfig.h"
#import "HCMyCouponController.h"
@implementation HCRouterUrlService
+ (void)handleUrlWithUserInfo:(NSDictionary *)userInfo {
    
    if ([userInfo.allKeys containsObject:@"type"]) {
        NSInteger type = [userInfo[@"type"] integerValue];
        switch (type) {
            case 1://具体h5页面
            {
                NSString * url = userInfo[@"url"];
                UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
                UINavigationController * navigationController = [self getCurrentNavigationController];
                [navigationController pushViewController:controller animated:YES];

            }
                break;
            case 2://投资列表页
            {
                UINavigationController * navigationController = [self getCurrentNavigationController];
                if ([[UIApplication sharedApplication].windows[0].rootViewController isKindOfClass:[UITabBarController class]]) {
                    UITabBarController * tabBarController = (UITabBarController *)[UIApplication sharedApplication].windows[0].rootViewController;
                    if (tabBarController.presentedViewController) {
                        [tabBarController.presentedViewController dismissViewControllerAnimated:NO completion:NULL];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        tabBarController.selectedIndex = 1;
                    });
                    [navigationController popToRootViewControllerAnimated:YES];
                }
                
            }
                break;
            case 3://具体项目页
            {
                NSString * projectName = userInfo[@"projectName"];
                NSString * projectNumber = userInfo[@"projectNumber"];
                UINavigationController * navigationController = [self getCurrentNavigationController];
                
                NSString * projectUrl = [NSString stringWithFormat:@"%@project/%@",WebBaseURL,projectNumber];
                HCInvestWebController * investWebVC = [[HCInvestWebController alloc] initWithAddress:projectUrl];
                investWebVC.projectNumber = projectNumber;
                investWebVC.webTitle = projectName;
                [navigationController pushViewController:investWebVC animated:YES];
                
            }
                break;
            case 4://会员中心
            {
                NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
                if (user) {
                    //已经登录
                    HCMemberCenterController * controller = [HCMemberCenterController new];
                    UINavigationController * navigationController = [self getCurrentNavigationController];
                    [navigationController pushViewController:controller animated:YES];

                }
            }
                break;
            case 5:
            {
                NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
                if (user) {
                    //已经登录
                    HCMyCouponController * controller = [HCMyCouponController new];
                    controller.index = [userInfo[@"index"] integerValue];
                    UINavigationController * navigationController = [self getCurrentNavigationController];
                    [navigationController pushViewController:controller animated:YES];

                }
                
            }
            default:
                break;
        }
        }
}
+ (UINavigationController *)getCurrentNavigationController {
    
    UIViewController * controller = [UIApplication sharedApplication].windows[0].rootViewController;
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController * tabBarController = (UITabBarController *)controller;
        UINavigationController * navigationController = tabBarController.selectedViewController;
        if (navigationController.presentedViewController) {
            if ([navigationController.presentedViewController isKindOfClass:NSClassFromString(@"HCLoginNavigationController")]) {
                [navigationController.presentedViewController dismissViewControllerAnimated:NO completion:NULL];
                return navigationController;
            }
            if ([navigationController.presentedViewController isKindOfClass:[UINavigationController class]]||[tabBarController.presentedViewController isKindOfClass:NSClassFromString(@"HCSettingLockController")]) {
                return navigationController;
            }else{
                [navigationController.presentedViewController dismissViewControllerAnimated:NO completion:NULL];
                return navigationController;
            }
        }
        return navigationController;
    }
    return nil;
}
@end

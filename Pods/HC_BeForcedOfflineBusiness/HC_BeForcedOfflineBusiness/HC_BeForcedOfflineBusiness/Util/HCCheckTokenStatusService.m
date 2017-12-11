//
//  HCCheckTokenStatusService.m
//  HC_BeForcedOfflineBusiness
//
//  Created by 郭金山 on 2017/9/14.
//  Copyright © 2017年 candy. All rights reserved.
//

#import "HCCheckTokenStatusService.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCCheckTokenStatusApi.h"
#import "HCBeForcedOfflineView.h"
#import <TYAlertController/UIView+TYAlertView.h>
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>

static BOOL _isRequest;

@implementation HCCheckTokenStatusService

+ (void)checkTokenStatus {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSInteger isAppearBeForcedOfflineView = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isAppearBeForcedOfflineView"] integerValue];
    UIViewController * rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    if (!_isRequest &&isAppearBeForcedOfflineView==0 && user && [rootVC isKindOfClass:[UITabBarController class]]) {
        NSString * token = user[@"token"];
        _isRequest = YES;
        HCCheckTokenStatusApi * api = [[HCCheckTokenStatusApi alloc] initWithToken:token];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            _isRequest = NO;
            
            if (request.responseObject) {
                BOOL status = [request.responseJSONObject[@"status"] boolValue];
                if (status==false) {
                    UIWindow * topWindow = [UIApplication sharedApplication].windows.firstObject;
                    [topWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[HCBeForcedOfflineView class]]) {
                            [obj removeFromSuperview];
                        }
                    }];
                    
                    [self showOfflineView];
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            _isRequest = NO;
        }];
    }
}
+ (void)showOfflineView {
    [[CTMediator sharedInstance] HCUserBusiness_removeUser];
    NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [storage deleteCookie:obj];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"isHideMoney"];
    
    HCBeForcedOfflineView * view = [[HCBeForcedOfflineView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-50, 0)];
    view.layer.cornerRadius = 8.f;
    __weak typeof(HCBeForcedOfflineView *) weakView = view;
    view.loginButtonCallBack = ^{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isAppearBeForcedOfflineView"];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIViewController *controller = [window rootViewController].presentedViewController;
        if (controller) {
            do {
                [controller.presentedViewController dismissViewControllerAnimated:NO completion:NULL];
                controller = controller.presentedViewController;
                
            } while (controller.presentedViewController != nil);
            [[window rootViewController].presentedViewController dismissViewControllerAnimated:NO completion:^{
                UITabBarController * myTabBarVC = (UITabBarController *)[window rootViewController];
                [myTabBarVC.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableArray * array = [NSMutableArray array];
                    [array addObject:obj.viewControllers.firstObject];
                    [obj setViewControllers:array];
                }];
                
                [weakView hideInWindow];
                
                id  tabBarControllerConfig = [NSClassFromString(@"HCTabBarControllerConfig") new];
                UITabBarController * tabBarVC = [tabBarControllerConfig valueForKey:@"tabBarController"];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
                UIViewController * loginVC = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
                [tabBarVC presentViewController:loginVC animated:NO completion:NULL];
                
            }];
        }else {
            UITabBarController * myTabBarVC = (UITabBarController *)[window rootViewController];
            [myTabBarVC.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray * array = [NSMutableArray array];
                [array addObject:obj.viewControllers.firstObject];
                [obj setViewControllers:array];
            }];
            
            [weakView hideInWindow];
            
            id  tabBarControllerConfig = [NSClassFromString(@"HCTabBarControllerConfig") new];
            UITabBarController * tabBarVC = [tabBarControllerConfig valueForKey:@"tabBarController"];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
            UIViewController * loginVC = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
            [tabBarVC presentViewController:loginVC animated:NO completion:NULL];
            
            
        }
        
    };
    [[NSUserDefaults standardUserDefaults] setObject:@"isAppearBeForcedOfflineView" forKey:@"1"];
    
    BOOL isAppearInIPhone4Or5 = NO;
    
    
    
    UIViewController * rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabBarVC = (UITabBarController *)rootVC;
        
        UINavigationController * nav = tabBarVC.selectedViewController;
        
        UIViewController * visibleVC = nav.visibleViewController;
        
        if ([visibleVC isKindOfClass:[TYAlertController class]]) {
            TYAlertController * myAlertVC = (TYAlertController *)visibleVC;
            if ([myAlertVC.alertView isKindOfClass:NSClassFromString(@"HCGoToInvestView")] || [myAlertVC.alertView isKindOfClass:NSClassFromString(@"HCGoToTransferView")]) {
                switch ((NSInteger)CGRectGetHeight([UIScreen mainScreen].bounds)) {
                    case 480:
                        isAppearInIPhone4Or5 = YES;
                        [view showInWindowWithOriginY:60];
                        break;
                    case 568:
                        [view showInWindowWithOriginY:150];
                        isAppearInIPhone4Or5 = YES;
                        break;
                }
                
            }
            
        }
        
    }
    
    if (!isAppearInIPhone4Or5) {
        [view showInWindow];
    }
}
@end

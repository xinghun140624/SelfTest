//
//  AppDelegate.m
//  HongCai
//
//  Created by Candy on 2017/5/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+ThirdService.h"
#import "AppDelegate+AppService.h"
#import <HC_GestureBusiness/HCSettingGestureService.h>
#import <HC_GestureBusiness/HCSettingLockController.h>
#import "HCHomeController.h"
#import "HCTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_allowRotate == 1) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}
// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate {
    if (_allowRotate == 1) {
        return YES;
    }
    
    return NO;
}
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier {
    return NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupThirdService];
    [self initWindow];
    [self initAdWindow];
#if !TARGET_IPHONE_SIMULATOR
    [self setupPushNotification:launchOptions];
#endif
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSString *hc_userLastEnterBackgroundTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    [[NSUserDefaults standardUserDefaults] setObject:hc_userLastEnterBackgroundTime forKey:@"hc_userLastEnterBackgroundTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"进入后台，存入最后时间：%@",hc_userLastEnterBackgroundTime);
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [HCSettingGestureService getUserGesture:^(BOOL success, NSString *gesture) {
        if (success && gesture.length>=4) {
            NSString * hc_userLastEnterBackgroundTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"hc_userLastEnterBackgroundTime"];
            if (hc_userLastEnterBackgroundTime ==nil || !(success && gesture.length>=4)) {
                NSLog(@"条件不满足");
                return;
            }else {
                NSTimeInterval time =  [[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:hc_userLastEnterBackgroundTime.doubleValue]];
                //if (time>=60*5) {
                if (YES) {
                    NSLog(@"条件满足");
                    HCSettingLockController * settingLock =[[HCSettingLockController alloc] init];
                    settingLock.type = GestureViewControllerTypeLogin;
                    [self.window.rootViewController presentViewController:settingLock animated:NO completion:NULL];
                    settingLock.dimissCallBack = ^{
                        if ([[self getCurrentVC] isKindOfClass:[HCHomeController class]]) {
                               HCHomeController *homeVC = (HCHomeController*)[self getCurrentVC];
                             [homeVC requestActivityBirthday];
                        }
                    };
                }
            }
        }else{
            if ([[self getCurrentVC] isKindOfClass:[HCHomeController class]]) {
                HCHomeController *homeVC = (HCHomeController*)[self getCurrentVC];
                [homeVC requestActivityBirthday];
            }
        }
    }];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[HCTabBarController class]]) {
        HCTabBarController *tab = (HCTabBarController *)result;
        result = tab.selectedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)result;
        result = navi.topViewController;
    }
    
    return result;
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end

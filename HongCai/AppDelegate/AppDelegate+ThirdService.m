//
//  AppDelegate+ThirdService.m
//  HongCai
//
//  Created by Candy on 2017/6/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "AppDelegate+ThirdService.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMengServiceKeys.h"
#import <UserNotifications/UserNotifications.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <CTMediator/CTMediator.h>
#import <GrowingIO/Growing.h>
#import <Bugly/Bugly.h>
#import "HCRouterUrlService.h"

#define BUGLY_APP_ID @"61fc444e07"


@implementation AppDelegate (ThirdService)

- (void)setupThirdService {
 
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Growing startWithAccountId:@"bbd8be057b264565"];
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppId appSecret:nil redirectURL:nil];
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppId appSecret:WXAppSecret redirectURL:nil];
        BuglyConfig * config = [[BuglyConfig alloc] init];
#if DEBUG
        config.debugMode = YES;
#endif
        config.version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        config.consolelogEnable = NO;
        config.viewControllerTrackingEnable = NO;
        [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
            developmentDevice:YES
#endif
                       config:config];
        
        [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
        
        [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    });
        [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

   
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([Growing handleUrl:url]) {
        return YES;
    } ;
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
    }
    
    if ([url.scheme  isEqualToString:@"hongcai"]) {
        return [[[CTMediator sharedInstance] performActionWithUrl:url completion:nil] boolValue];
    }
    return result;
}
#pragma mark Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webUrl = userActivity.webpageURL;
        [self handleUniversalLink:webUrl]; // 转化为App路由
    }
    return YES;
}
- (void)handleUniversalLink:(NSURL *)webUrl {
    NSURLComponents *components = [NSURLComponents componentsWithURL:webUrl resolvingAgainstBaseURL:YES];
    NSString *host = components.host;
    NSArray *pathComponents = components.queryItems;
    if ([host isEqualToString:@"oia.hongcai.com"]) { //host判断，虽然没啥意义
        NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
        [pathComponents enumerateObjectsUsingBlock:^(NSURLQueryItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [userInfo setObject:obj.value forKey:obj.name];
        }];
        [HCRouterUrlService handleUrlWithUserInfo:userInfo];
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.scheme isEqualToString:@"hongcai"]) {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
        [queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [userInfo setObject:obj.value forKey:obj.name];
        }];
        [HCRouterUrlService handleUrlWithUserInfo:userInfo];
    }
    if ([Growing handleUrl:url]) {
        return YES;
    } ;
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        //其他SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([Growing handleUrl:url]) {
        return YES;
    };
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#if !TARGET_IPHONE_SIMULATOR

- (void)setupPushNotification:(NSDictionary *)launchOptions {
    //可以添加自定义categories
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|JPAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else{
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        
    }
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState== UIApplicationStateActive) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HCSystemNotification" object:nil userInfo:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark- JPUSHRegisterDelegate


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
 didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HCSystemNotification" object:nil userInfo:userInfo];
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);// 系统要求执行这个方法
}
#endif
@end

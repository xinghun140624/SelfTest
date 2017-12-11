//
//  AppDelegate+ThirdService.h
//  HongCai
//
//  Created by Candy on 2017/6/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "AppDelegate.h"
#if !TARGET_IPHONE_SIMULATOR
#import <JPush/JPUSHService.h>
static NSString *appKey = @"f271bbc479df8ed1e1332070";
static NSString *channel = @"Publish channel";
#endif

static BOOL isProduction = YES;

@interface AppDelegate (ThirdService)
#if !TARGET_IPHONE_SIMULATOR
<JPUSHRegisterDelegate>
#endif
- (void)setupThirdService;

#if !TARGET_IPHONE_SIMULATOR
- (void)setupPushNotification:(NSDictionary *)launchOptions;
#endif
@end

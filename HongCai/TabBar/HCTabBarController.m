//
//  HCTabBarController.m
//  HongCai
//
//  Created by Candy on 2017/5/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCTabBarController.h"
#import "HCRouterUrlService.h"




@implementation HCTabBarController


- (void) viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"HCSystemNotification" object:nil];
    
    
   
   
}
- (void)receiveNotification:(NSNotification *)notification {
    if (notification.userInfo) {
        [HCRouterUrlService handleUrlWithUserInfo:notification.userInfo];
    }
}



@end

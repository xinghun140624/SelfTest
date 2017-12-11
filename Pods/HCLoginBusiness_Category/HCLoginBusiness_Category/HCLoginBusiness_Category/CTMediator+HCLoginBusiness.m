//
//  CTMediator+HCLoginBusiness.m
//  HCLoginBusiness_Category
//
//  Created by Candy on 2017/6/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCLoginBusiness.h"
NSString *const HC_LoginSuccessNotification = @"HC_LoginSuccessNotification";

@implementation CTMediator (HCLoginBusiness)
- (UIViewController *)HCLoginBusiness_viewController {
    return [self performTarget:@"HCLoginBusiness" action:@"viewController" params:nil shouldCacheTarget:NO];
}
- (UIViewController *)HCLoginBusiness_modifyBingdingMobileViewController {
    return [self performTarget:@"HCLoginBusiness" action:@"modifyBingdingMobileViewController" params:nil shouldCacheTarget:NO];
}
- (UIViewController *)HCLoginBusiness_bindingNewMobileViewController {
    return [self performTarget:@"HCLoginBusiness" action:@"bindingNewMobileViewController" params:nil shouldCacheTarget:NO];
}
- (UIViewController *)HCLoginBusiness_settingLoginPasswordController {
    return [self performTarget:@"HCLoginBusiness" action:@"settingLoginPasswordController" params:nil shouldCacheTarget:NO];
}
- (UIViewController *)HCLoginBusiness_modifyLoginPasswordController {
    return [self performTarget:@"HCLoginBusiness" action:@"modifyLoginPasswordController" params:nil shouldCacheTarget:NO];
}

@end

//
//  Target_HCSettingBusiness.m
//  HC_SettingBusiness
//
//  Created by Candy on 2017/6/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCSettingBusiness.h"
#import "HCSettingController.h"

@implementation Target_HCSettingBusiness
- (UIViewController *)Action_viewController:(NSDictionary *)params {
//    if (!params) {
//        return nil;
//    }
    HCSettingController * viewController = [[HCSettingController alloc] init];
    return viewController;
}
@end

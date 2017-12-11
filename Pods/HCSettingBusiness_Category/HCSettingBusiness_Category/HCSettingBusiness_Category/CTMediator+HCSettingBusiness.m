//
//  CTMediator+HCSettingBusiness.m
//  HCSettingBusiness_Category
//
//  Created by Candy on 2017/6/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCSettingBusiness.h"

@implementation CTMediator (HCSettingBusiness)
- (UIViewController *)HCSettingBusiness_viewController {
    return [self performTarget:@"HCSettingBusiness" action:@"viewController" params:nil shouldCacheTarget:NO];
}
@end

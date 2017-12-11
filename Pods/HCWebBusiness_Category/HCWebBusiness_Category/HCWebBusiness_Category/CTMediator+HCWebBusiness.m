//
//  CTMediator+HCWebBusiness.m
//  HCWebBusiness_Category
//
//  Created by Candy on 2017/6/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCWebBusiness.h"
 NSString  const* HCWebBusinessNavigationType = @"navigationType";
 NSString  const* HCWebBusinessUrlKey = @"url";
 NSString  const* HCNavigationItemKey = @"itemTitle";
@implementation CTMediator (HCWebBusiness)
- (UIViewController *)HCWebBusiness_viewController:(NSDictionary *)params {
    return [self performTarget:@"HCWebBusiness" action:@"viewController" params:params shouldCacheTarget:NO];
}
@end

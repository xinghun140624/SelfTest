//
//  CTMediator+HCMessageBusiness.m
//  HCMessageBusiness_Category
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCMessageBusiness.h"

@implementation CTMediator (HCMessageBusiness)
- (UIViewController *)HCMessageBusiness_viewControllerWithIndex:(NSInteger)index
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"index"] = @(index);
    return [self performTarget:@"HCMessageBusiness" action:@"viewController" params:params shouldCacheTarget:NO];
}
@end

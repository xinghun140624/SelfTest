//
//  CTMediator+HCMyInvesetmentBusiness.m
//  HCMyInvesetmentBusiness_Category
//
//  Created by Candy on 2017/6/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCMyInvesetmentBusiness.h"

@implementation CTMediator (HCMyInvesetmentBusiness)
- (UIViewController *)HCMyInvesetmentBusiness_viewController {
    return [self performTarget:@"HCMyInvesetmentBusiness" action:@"viewController" params:nil shouldCacheTarget:NO];
}
@end

//
//  CTMediator+HCMyAssetsBusiness.m
//  HCMyAssetsBuiness_Category
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCMyAssetsBusiness.h"

@implementation CTMediator (HCMyAssetsBusiness)
- (UIViewController *)HCMyAssetsBusiness_viewController {
    return [self performTarget:@"HCMyAssetsBusiness" action:@"viewController" params:nil shouldCacheTarget:NO];
}
@end

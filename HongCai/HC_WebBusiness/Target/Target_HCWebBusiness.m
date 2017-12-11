//
//  Target_HCWebBusiness.m
//  HC_WebBusiness
//
//  Created by Candy on 2017/6/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCWebBusiness.h"
#import "HCWebController.h"

@implementation Target_HCWebBusiness
- (UIViewController *)Action_viewController:(NSDictionary *)params {
    if (!params) {
        return nil;
    }
    if ([params.allKeys containsObject:@"url"]) {
        HCWebController * viewController = [[HCWebController alloc] initWithURL:[NSURL URLWithString:params[@"url"]]];
        viewController.showsBackgroundLabel = NO;
        if ([params.allKeys containsObject:@"navigationType"]) {
            viewController.navigationType = AXWebViewControllerNavigationToolItem;
            viewController.showsToolBar = NO;
        }
        if ([params.allKeys containsObject:@"itemTitle"]) {
            viewController.rightBarButtonTitle =params[@"itemTitle"];
        }
        return viewController;

    }
    return nil;
}
@end

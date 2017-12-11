//
//  Target_HCMyAssetsBusiness.m
//  Pods
//
//  Created by Candy on 2017/6/26.
//
//

#import "Target_HCMyAssetsBusiness.h"
#import "HCMyAssetsController.h"

@implementation Target_HCMyAssetsBusiness
- (UIViewController *)Action_viewController:(NSDictionary *)params {
    HCMyAssetsController *controller = [[HCMyAssetsController alloc] init];
    return controller;
}
@end

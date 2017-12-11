//
//  Target_HCShareBusiness.m
//  HC_ShareBusiness
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCShareBusiness.h"
#import <TYAlertController/TYAlertController.h>
#import "HCShareView.h"
typedef void(^blockCallBack)(NSDictionary * info);
@implementation Target_HCShareBusiness
- (UIViewController *)Action_shareController:(NSDictionary *)params {
    HCShareView * shareView = [[HCShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 220)];
    shareView.type = [params[@"shareType"] integerValue];
    TYAlertController * controller = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleActionSheet transitionAnimation:TYAlertTransitionAnimationFade];
    blockCallBack shareButtonClickCallBack = params[@"shareButtonClickCallBack"];
    controller.backgoundTapDismissEnable = YES;
    __weak typeof(UIViewController *)weakVC = controller;
    
    
    shareView.cancelButtonClickCallBack = ^(NSInteger index) {
        [weakVC dismissViewControllerAnimated:YES completion:NULL];
    };
    
    shareView.shareButtonClickCallBack = ^(NSInteger index) {
        [weakVC dismissViewControllerAnimated:YES completion:NULL];
        
        if (shareButtonClickCallBack) {
            shareButtonClickCallBack(@{@"type":@(index),@"controller":weakVC});
        }
    };
    return controller;
}
@end

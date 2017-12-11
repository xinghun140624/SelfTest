//
//  Target_HCShowNotPayViewBusiness.m
//  HC_GoToInvestBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCShowNotPayViewBusiness.h"
#import <TYAlertController/TYAlertController.h>
#import "HCNotPayOrderView.h"
typedef void(^blockCallBack)(NSDictionary * info);

@implementation Target_HCShowNotPayViewBusiness
- (UIViewController *)Action_showNotPayOrderView:(NSDictionary *)params {
    HCNotPayOrderView * view = [[HCNotPayOrderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)==812.0?420+75.0:420)];
    NSDictionary * detailParams = params[@"detailParams"];
    view.params = detailParams;
    
    UIViewController * controller = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleActionSheet transitionAnimation:TYAlertTransitionAnimationFade];
    
    __weak UIViewController * weakVC = controller;
    blockCallBack countinueButtonClickCallBack = params[@"countinueButtonClickCallBack"];
    view.countinueButtonClickCallBack = ^{
        if (countinueButtonClickCallBack) {
            countinueButtonClickCallBack(@{@"controller":weakVC});
        }
    };
    return controller;
    
}
@end

//
//  Target_HCGoToTransferBusiness.m
//  HC_GoToInvestBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCGoToTransferBusiness.h"
#import <TYAlertController/TYAlertController.h>
#import "HCGoToTransferView.h"
#import "HCAlertShortFadeAnimation.h"
typedef void(^blockCallBack)(NSDictionary * info);

@implementation Target_HCGoToTransferBusiness
- (UIViewController *)Action_gotoTransferInvest:(NSDictionary *)params {
    
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds)==812?420+75:420;
    
    HCGoToTransferView * view = [[HCGoToTransferView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
    NSDictionary * detailParams = params[@"detailParams"];
    view.projectDays = detailParams[@"remainDay"];
    view.remainAmount = @([detailParams[@"currentStock"] integerValue]*100);
    view.amount =@([detailParams[@"amount"] integerValue]);

    view.projectId = detailParams[@"projectId"];
    view.annualEarnings = detailParams[@"annualEarnings"];
    view.originalAnnualEarnings = detailParams[@"originalAnnualEarnings"];
    view.number = detailParams[@"number"];
    UIViewController * controller = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleActionSheet transitionAnimationClass:[HCAlertShortFadeAnimation class]];
    
    __weak HCGoToTransferView * weakView = view;
    __weak UIViewController * weakVC = controller;

    blockCallBack gotoInvestButtonClickCallBack = params[@"gotoInvestButtonClickCallBack"];
    view.gotoInvestButtonClickCallBack = ^{
        if (gotoInvestButtonClickCallBack) {
            
            gotoInvestButtonClickCallBack(@{@"view":weakView,
                                            @"controller":weakVC,
                                            @"investAmount":weakView.investAmount});
        }
    };

    return controller;
    
}

@end

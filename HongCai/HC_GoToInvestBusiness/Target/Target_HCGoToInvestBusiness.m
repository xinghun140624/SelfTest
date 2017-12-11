//
//  Target_HCInvesetmentBusiness.m
//  HC_InvesetmentBusiness
//
//  Created by Candy on 2017/6/23.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCGoToInvestBusiness.h"
#import <TYAlertController/TYAlertController.h>
#import "HCGoToInvestView.h"
#import "HCGoToTransferView.h"
#import "HCAlertShortFadeAnimation.h"

typedef void(^blockCallBack)(NSDictionary * info);
@implementation Target_HCGoToInvestBusiness
- (UIViewController *)Action_gotoInvest:(NSDictionary *)params {
    HCGoToInvestView * view  = [[HCGoToInvestView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)==812.0?420+75.0:420)];

    
    NSDictionary * detailParams = params[@"detailParams"];
    
    view.projectDays = detailParams[@"projectDays"];
    view.amount = @([detailParams[@"amount"] integerValue]);
    view.projectId = detailParams[@"projectId"];
    view.annualEarnings = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",detailParams[@"annualEarnings"]]];
    view.projectNumber = detailParams[@"projectNumber"];
    view.level = [detailParams[@"level"] intValue];
    view.isPartake =[detailParams[@"isPartake"] boolValue];
    view.specialInvestDesc =detailParams[@"specialInvestDesc"];

    view.minInvestAmount =[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",detailParams[@"minInvestAmount"]]];
    UIViewController * controller = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleActionSheet transitionAnimationClass:[HCAlertShortFadeAnimation class]];
   
    __weak HCGoToInvestView * weakView = view;
    __weak UIViewController * weakVC = controller;
    blockCallBack gotoInvestButtonClickCallBack = params[@"gotoInvestButtonClickCallBack"];
    view.gotoInvestButtonClickCallBack = ^(int level,NSInteger type,UIButton * confirmButton) {
        if (gotoInvestButtonClickCallBack) {
            gotoInvestButtonClickCallBack(@{  @"view":weakView,
                                              @"confirmButton":confirmButton,
                                              @"level":@(level),
                                              @"controller":weakVC,
                                              @"investAmount":weakView.investAmount,
                                              @"couponNumber":weakView.couponNumber?weakView.couponNumber:@"",
                                              @"type":@(type)});
        }
        
    };
 
    return controller;
    
}

@end

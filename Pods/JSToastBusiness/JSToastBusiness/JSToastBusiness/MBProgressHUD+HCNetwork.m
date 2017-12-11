//
//  MBProgressHUD+HCNetwork.m
//  JSToastBusiness
//
//  Created by Candy on 2017/7/29.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "MBProgressHUD+HCNetwork.h"
#import "HCLoadingView.h"
#import "HCNetworkFailView.h"
@implementation MBProgressHUD (HCNetwork)
+ (void)showFullScreenLoadingView:(UIView *)fromView {
    MBProgressHUD * hud = nil;
    if ([MBProgressHUD HUDForView:fromView]) {
        hud = [MBProgressHUD HUDForView:fromView];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:fromView animated:YES];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[HCLoadingView alloc] init];
    hud.bezelView.color = [UIColor whiteColor];
    hud.button.hidden = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:1 alpha:1];
    hud.square = YES;
}
+ (void)showNetWorkView:(UIView *)fromView reloadClick:(void(^)(void))reloadCallback {
    MBProgressHUD * hud = nil;
    if ([MBProgressHUD HUDForView:fromView]) {
        hud = [MBProgressHUD HUDForView:fromView];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:fromView animated:YES];
    }
    hud.mode = MBProgressHUDModeCustomView;
    HCNetworkFailView * failView =  [[HCNetworkFailView alloc] init];
    failView.reloadViewCallBack = ^{
        if (reloadCallback) {
            reloadCallback();
        }
    };
    hud.customView = failView;
    hud.bezelView.color = [UIColor whiteColor];
    hud.button.hidden = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:1 alpha:1];
    hud.square = YES;


}
@end

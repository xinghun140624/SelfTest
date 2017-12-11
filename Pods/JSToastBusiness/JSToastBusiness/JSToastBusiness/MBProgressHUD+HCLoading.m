//
//  MBProgressHUD+HCLoading.m
//  JSToastBusiness
//
//  Created by Candy on 2017/7/29.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "MBProgressHUD+HCLoading.h"

@implementation MBProgressHUD (HCLoading)
+ (void)showLoadingFromView:(UIView *)fromView {
    MBProgressHUD * hud = nil;
    if ([MBProgressHUD HUDForView:fromView]) {
        hud = [MBProgressHUD HUDForView:fromView];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:fromView animated:YES];
    }
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = @"加载中...";
    
}
@end

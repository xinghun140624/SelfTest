//
//  MBProgressHUD+Reminding.m
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/10/20.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "MBProgressHUD+Reminding.h"
#import "HCMineRemindingView.h"
#import "HCProjectDetailRemindingView.h"
#import "HCMemberCenterRemindingView.h"
@implementation MBProgressHUD (Reminding)

+ (void)showMineRemindingViewFromView:(UIView *)fromView {
    MBProgressHUD * hud = nil;
    if ([MBProgressHUD HUDForView:fromView]) {
        hud = [MBProgressHUD HUDForView:fromView];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:fromView animated:NO];
    }
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.margin = 0.f;
    hud.mode = MBProgressHUDModeCustomView;
    HCMineRemindingView * mineRemindingView =[[HCMineRemindingView alloc] init];
    hud.customView = mineRemindingView;
    __weak typeof(hud) weakHud = hud;
    
    mineRemindingView.tapClick = ^{
        [weakHud hideAnimated:NO];
    };
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    hud.button.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"mine_Reminding"];
}
+ (void)showProjectDetailRemindingViewFromView:(UIView *)fromView {
    MBProgressHUD * hud = nil;
    if ([MBProgressHUD HUDForView:fromView]) {
        hud = [MBProgressHUD HUDForView:fromView];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:fromView animated:NO];
    }
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.margin = 0.f;
    hud.mode = MBProgressHUDModeCustomView;
    HCProjectDetailRemindingView * projectDetailRemindingView =[[HCProjectDetailRemindingView alloc] init];
    hud.customView = projectDetailRemindingView;
    __weak typeof(hud) weakHud = hud;
    
    projectDetailRemindingView.tapClick = ^{
        [weakHud hideAnimated:NO];
    };
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    hud.button.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"projectDetail_Reminding"];

}
+ (void)showMemberCenterRemindingView:(CGRect)section1Frame FromView:(UIView *)fromView {

    MBProgressHUD * hud = nil;
    if ([MBProgressHUD HUDForView:fromView]) {
        hud = [MBProgressHUD HUDForView:fromView];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:fromView animated:NO];
    }
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.margin = 0.f;
    hud.mode = MBProgressHUDModeCustomView;
    HCMemberCenterRemindingView * memberCenterRemindingView =[[HCMemberCenterRemindingView alloc] init];
    memberCenterRemindingView.section1Frame = section1Frame;
    hud.customView = memberCenterRemindingView;
    __weak typeof(hud) weakHud = hud;
    
    memberCenterRemindingView.tapClick = ^{
        [weakHud hideAnimated:NO];
    };
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    hud.button.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"memberCenter_Reminding"];


    
}
@end

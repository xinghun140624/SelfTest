//
//  MBProgressHUD+AdView.m
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/8/15.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "MBProgressHUD+AdView.h"
#import "HCAdView.h"
@implementation MBProgressHUD (AdView)
+ (void)showAdImage:(UIImage *)image fromView:(UIView *)fromView imageClick:(void(^)(void))clickCallBack
{
    MBProgressHUD * hud = nil;
    if ([MBProgressHUD HUDForView:fromView]) {
        hud = [MBProgressHUD HUDForView:fromView];
    }else{
        hud = [MBProgressHUD showHUDAddedTo:fromView animated:YES];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 0;
    HCAdView * adView = [[HCAdView alloc] init];
    adView.imageClick = ^{
        if (clickCallBack) {
            clickCallBack();
        }
    };
    adView.containerView = fromView;
    adView.image = image;
    hud.customView = adView;
    hud.bezelView.color = [UIColor whiteColor];
    hud.button.hidden = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:1 alpha:1];
    hud.square = YES;
}
@end

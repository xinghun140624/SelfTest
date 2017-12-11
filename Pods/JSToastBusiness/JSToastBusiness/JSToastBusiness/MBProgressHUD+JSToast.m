//
//  MBProgressHUD+HCCategory.m
//  HongCai
//
//  Created by Candy on 2017/7/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "MBProgressHUD+JSToast.h"
@implementation MBProgressHUD (JSToast)
+ (void)showText:(NSString *)text {
    [self showText:text delay:1.f];
}
+ (void)showText:(NSString *)text delay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 0);
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.bezelView.opaque = NO;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:13.f];
    [hud hideAnimated:YES afterDelay:delay];
}
@end

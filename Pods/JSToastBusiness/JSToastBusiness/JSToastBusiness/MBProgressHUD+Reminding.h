//
//  MBProgressHUD+Reminding.h
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/10/20.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Reminding)
+ (void)showMineRemindingViewFromView:(UIView *)fromView;

+ (void)showProjectDetailRemindingViewFromView:(UIView *)fromView;

+ (void)showMemberCenterRemindingView:(CGRect)section1Frame FromView:(UIView *)fromView;

@end

//
//  MBProgressHUD+HCNetwork.h
//  JSToastBusiness
//
//  Created by Candy on 2017/7/29.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HCNetwork)
+ (void)showFullScreenLoadingView:(UIView *)fromView;
+ (void)showNetWorkView:(UIView *)fromView reloadClick:(void(^)(void))reloadCallback;

@end

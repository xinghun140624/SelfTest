//
//  MBProgressHUD+HCCategory.h
//  HongCai
//
//  Created by Candy on 2017/7/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "MBProgressHUD.h"
@interface MBProgressHUD (JSToast)
+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text delay:(NSTimeInterval)delay;
@end

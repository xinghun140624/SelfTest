//
//  MBProgressHUD+AdView.h
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/8/15.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (AdView)
+ (void)showAdImage:(UIImage *)image fromView:(UIView *)fromView imageClick:(void(^)(void))clickCallBack;
@end

//
//  NSBundle+HCMyCouponModule.m
//  HongCai
//
//  Created by Candy on 2017/7/18.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+HCMyCouponModule.h"

@implementation NSBundle (HCMyCouponModule)
+ (UIImage *)couponBusiness_ImageWithName:(NSString *)imageName {

    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCMyCouponController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCMyCouponBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;

}
@end

//
//  NSBundle+HCMoneyModule.m
//  HongCai
//
//  Created by Candy on 2017/7/23.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+HCMoneyModule.h"

@implementation NSBundle (HCMoneyModule)
+ (UIImage *)money_ImageWithName:(NSString *)imageName{
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCRechargeController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCMoneyModuleImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

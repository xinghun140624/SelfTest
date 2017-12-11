//
//  NSBundle+HCGateWayModule.m
//  HC_GateWayBusiness
//
//  Created by Candy on 2017/7/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+HCGateWayModule.h"

@implementation NSBundle (HCGateWayModule)
+ (UIImage *)gateWay_ImageWithName:(NSString *)imageName{
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCGateWaySuccessController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCGateWayBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

//
//  NSBundle+InvesementModule.m
//  HC_InvesetmentBusiness
//
//  Created by Candy on 2017/6/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+GoToInvestModule.h"

@implementation NSBundle (GoToInvestModule)
+ (UIImage *)goToInvest_ImageWithName:(NSString *)imageName{
    UIImage *image = nil;
    if (image == nil) {
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCGoToInvestView")];
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCGoToInvestBusinessImage" ofType:@"bundle"]];
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

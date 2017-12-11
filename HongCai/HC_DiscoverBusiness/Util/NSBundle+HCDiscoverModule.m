//
//  NSBundle+HCDiscoverModule.m
//  HongCai
//
//  Created by Candy on 2017/7/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+HCDiscoverModule.h"

@implementation NSBundle (HCDiscoverModule)
+ (UIImage *)discover_ImageWithName:(NSString *)imageName{
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCDiscoverController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCDiscoverBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

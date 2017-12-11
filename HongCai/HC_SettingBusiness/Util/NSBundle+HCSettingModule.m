//
//  NSBundle+HCSettingModule.m
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+HCSettingModule.h"

@implementation NSBundle (HCSettingModule)
+ (UIImage *)setting_ImageWithName:(NSString *)imageName {
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCSettingController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCSettingBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

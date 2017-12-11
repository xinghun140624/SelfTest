//
//  NSBundle+JSToastBusiness.m
//  JSToastBusiness
//
//  Created by Candy on 2017/7/29.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "NSBundle+JSToastBusiness.h"

@implementation NSBundle (JSToastBusiness)
+ (UIImage *)jSToastBusiness_ImageWithName:(NSString *)imageName {
    
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"MBProgressHUD")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"JSToastBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
    
    
}
@end

//
//  NSBundle+MyAssetsModule.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+MyAssetsModule.h"

@implementation NSBundle (MyAssetsModule)
+ (UIImage *)myAssets_ImageWithName:(NSString *)imageName{
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCMyAssetsController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCMyAssetsBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

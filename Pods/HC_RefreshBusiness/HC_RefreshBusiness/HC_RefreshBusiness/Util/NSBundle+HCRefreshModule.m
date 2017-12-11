//
//  NSBundle+HCRefreshModule.m
//  HC_RefreshBusiness
//
//  Created by 郭金山 on 2017/8/23.
//  Copyright © 2017年 candy. All rights reserved.
//

#import "NSBundle+HCRefreshModule.h"

@implementation NSBundle (HCRefreshModule)
+ (UIImage *)refresh_ImageWithName:(NSString *)imageName {
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCRefreshHeader")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCRefreshBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}



@end

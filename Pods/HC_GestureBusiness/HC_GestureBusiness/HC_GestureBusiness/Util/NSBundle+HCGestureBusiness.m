//
//  NSBundle+HCGestureBusiness.m
//  HC_GestureBusiness
//
//  Created by 郭金山 on 2017/8/23.
//  Copyright © 2017年 candy. All rights reserved.
//

#import "NSBundle+HCGestureBusiness.h"

@implementation NSBundle (HCGestureBusiness)
+ (UIImage *)gesture_ImageWithName:(NSString *)imageName{
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCSettingLockController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCGestureBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

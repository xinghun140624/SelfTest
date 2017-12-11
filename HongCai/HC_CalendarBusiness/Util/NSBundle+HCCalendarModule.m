//
//  NSBundle+HCCalendarModule.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+HCCalendarModule.h"

@implementation NSBundle (HCCalendarModule)
+ (UIImage *)calendar_ImageWithName:(NSString *)imageName {

    UIImage *image = nil;
    if (image == nil) {
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCCalendarController")];
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCCalendarBusinessImage" ofType:@"bundle"]];
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

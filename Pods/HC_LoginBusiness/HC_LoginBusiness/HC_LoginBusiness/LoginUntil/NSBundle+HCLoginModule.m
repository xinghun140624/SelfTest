//
//  NSBundle+HCLoginModule.m
//  Pods
//
//  Created by Candy on 2017/5/3.
//
//

#import "NSBundle+HCLoginModule.h"
@class HCLoginController;
@implementation NSBundle (HCLoginModule)

+ (UIImage *)login_ImageWithName:(NSString *)imageName{
     UIImage *image = nil;
    if (image == nil) { 
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCLoginController")];
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCLoginBusinessImage" ofType:@"bundle"]];
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

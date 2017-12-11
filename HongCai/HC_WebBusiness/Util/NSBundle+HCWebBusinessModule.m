//
//  NSBundle+HCWebBusinessModule.m
//  Pods
//
//  Created by Candy on 2017/7/18.
//
//

#import "NSBundle+HCWebBusinessModule.h"

@implementation NSBundle (HCWebBusinessModule)
+ (UIImage *)webBusiness_ImageWithName:(NSString *)imageName {


    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCWebController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCWebBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;

}
@end

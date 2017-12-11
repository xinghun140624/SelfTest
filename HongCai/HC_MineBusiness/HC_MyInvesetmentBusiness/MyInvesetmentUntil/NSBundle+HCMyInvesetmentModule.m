//
//  NSBundle+HCMyInvesetmentModule.m
//  Pods
//
//  Created by Candy on 2017/6/27.
//
//

#import "NSBundle+HCMyInvesetmentModule.h"

@implementation NSBundle (HCMyInvesetmentModule)
+ (UIImage *)myInvesetment_ImageWithName:(NSString *)imageName {
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCMyInvestmentController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCMyInvesetmentBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

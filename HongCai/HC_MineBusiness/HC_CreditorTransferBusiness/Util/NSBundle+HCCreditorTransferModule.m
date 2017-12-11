//
//  NSBundle+HCCreditorTransferModule.m
//  HongCai
//
//  Created by Candy on 2017/7/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "NSBundle+HCCreditorTransferModule.h"

@implementation NSBundle (HCCreditorTransferModule)
+ (UIImage *)creditorTransfer_ImageWithName:(NSString *)imageName {
    UIImage *image = nil;
    if (image == nil) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCCreditTransferController")];
        
        NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCCreditorTransferBusinessImage" ofType:@"bundle"]];
        
        image = [UIImage imageNamed:imageName inBundle:resourcesBundle compatibleWithTraitCollection:nil];
        
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}
@end

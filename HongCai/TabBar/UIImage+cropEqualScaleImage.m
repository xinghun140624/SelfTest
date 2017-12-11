//
//  UIImage+cropEqualScaleImage.m
//  BeiTaiKitchen
//
//  Created by Candy on 2017/11/24.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "UIImage+cropEqualScaleImage.h"

@implementation UIImage (cropEqualScaleImage)
- (UIImage *)bt_cropEqualScalesize:(CGSize)imageSize {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    CGSize aspectSize = CGSizeZero;
    if (self.size.width !=0 && self.size.height!=0) {
        CGFloat rateWith = imageSize.width/self.size.width;
        CGFloat rateHeight = imageSize.height/self.size.height;
        CGFloat rate = MIN(rateWith, rateHeight);
        aspectSize = CGSizeMake(self.size.width *rate, self.size.height * rate);
    }
    [self drawInRect:CGRectMake(0, 0, aspectSize.width, aspectSize.height)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

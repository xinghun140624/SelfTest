//
//  HCCouponService.h
//  HongCai
//
//  Created by Candy on 2017/7/18.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCCouponService : NSObject

+ (void)getCouponsWithType:(NSInteger)type Page:(NSInteger)page status:(NSArray *)status success:(void(^)(NSArray * coupons,BOOL finished))coupons;

@end

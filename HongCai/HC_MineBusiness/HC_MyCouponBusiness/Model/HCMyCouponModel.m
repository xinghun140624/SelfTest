//
//  HCMyCouponModel.m
//  HongCai
//
//  Created by Candy on 2017/6/23.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyCouponModel.h"

@implementation HCMyCouponModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"myCouponId" :@"id",
             @"desc":@"description"};
}


@end

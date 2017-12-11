//
//  HCInvestCouponModel.m
//  Pods
//
//  Created by Candy on 2017/6/29.
//
//

#import "HCGoToInvestCouponModel.h"

@implementation HCGoToInvestCouponModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"myCouponId" :@"id",
             @"desc":@"description"};
}
@end

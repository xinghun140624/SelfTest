//
//  HCUserCreditRightModel.m
//  HongCai
//
//  Created by Candy on 2017/7/18.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserCreditRightDetailModel.h"
#import "HCMyCouponModel.h"

@implementation HCCreditAssignmentFeeModel

@end

@implementation HCUserCreditRightModel

@end


@implementation HCUserCreditProjectModel


@end

@implementation HCProjectBillModel


@end

@implementation HCUserCreditRightDetailModel

+  (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"creditRightModel":@"creditRight",
             @"projectModel":@"project",
             @"projectBillModel":@"projectBill",
             @"couponModel":@"increaseRateCoupon",
             @"feeModel": @"creditAssignmentFee"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"creditRightModel" : [HCUserCreditRightModel class],
             @"projectModel" : HCUserCreditProjectModel.class,
             @"projectBillModel" : [HCProjectBillModel class],
             @"couponModel": [HCMyCouponModel class],
             @"feeModel": [HCCreditAssignmentFeeModel class]};
}

@end

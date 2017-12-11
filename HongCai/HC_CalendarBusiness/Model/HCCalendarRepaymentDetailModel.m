//
//  HCCalendarRepaymentDetailModel.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCalendarRepaymentDetailModel.h"


@implementation HCCalendarDetailVoModel



@end

@implementation HCCalendarRepaymentDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"details" : [HCCalendarDetailVoModel class]};
}
@end

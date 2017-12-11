//
//  HCUserAutoTenderModel.m
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserAutoTenderModel.h"

@implementation HCUserAutoTenderModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"user":[HCUser class]};
}
@end

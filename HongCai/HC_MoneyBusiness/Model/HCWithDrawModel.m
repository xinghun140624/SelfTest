//
//  HCWithDrawModel.m
//  HongCai
//
//  Created by Candy on 2017/11/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCWithDrawModel.h"

@implementation HCWithDrawModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"account":HCAccountModel.class,
             @"bankcard":HCUserBankCardModel.class};
}
@end

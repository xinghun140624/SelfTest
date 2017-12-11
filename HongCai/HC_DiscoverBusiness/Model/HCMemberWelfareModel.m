//
//  HCMemberWelfareModel.m
//  HongCai
//
//  Created by Candy on 2017/11/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberWelfareModel.h"
#import "HCMemberWelfareRuleModel.h"

@implementation HCMemberWelfareModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"welfareRules" : [HCMemberWelfareRuleModel class]};
}
@end

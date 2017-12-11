//
//  HCSpecialInvestModel.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSpecialInvestModel.h"
@implementation HCSpecialInvestRuleModel

@end
@implementation HCSpecialInvestModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"rules":[HCSpecialInvestRuleModel class]};
}
@end

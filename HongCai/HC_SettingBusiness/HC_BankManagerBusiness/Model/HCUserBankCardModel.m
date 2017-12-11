//
//  HCUserBankCardModel.m
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserBankCardModel.h"

@implementation HCUserBankCardModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"bankCardId":@"id"};
}
@end

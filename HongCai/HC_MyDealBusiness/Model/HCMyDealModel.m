//
//  HCMyDealModel.m
//  HC_MyDealBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyDealModel.h"

@implementation HCMyDealModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"desc":@"description",
             @"dealId":@"id"};
    
}
@end

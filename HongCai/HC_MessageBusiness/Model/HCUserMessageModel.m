//
//  HCUserMessageModel.m
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserMessageModel.h"

@implementation HCUserMessageModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"messageId":@"id"};
}
@end

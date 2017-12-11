//
//  HCActivityModel.m
//  HongCai
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCActivityModel.h"

@implementation HCActivityModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"activityId":@"id"};
}
@end

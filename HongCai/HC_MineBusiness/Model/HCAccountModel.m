//
//  HCAccountModel.m
//  HongCai
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAccountModel.h"

@implementation HCAccountModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"accoundId":@"id"};
}
@end

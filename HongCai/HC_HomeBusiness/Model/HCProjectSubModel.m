//
//  HCProjectSubModel.m
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCProjectSubModel.h"

@implementation HCProjectSubModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"projectId":@"id"};
}
@end

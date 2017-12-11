//
//  HCProjectModel.m
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCProjectModel.h"

@implementation HCProjectModel


+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"projectList" : [HCProjectSubModel class]};
}
@end

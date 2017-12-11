//
//  HCMemberInfoModel.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberInfoModel.h"
@implementation HCMemberInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"currentLevel" : [HCUserMemberModel class],
             @"nextLevel" : HCUserMemberModel.class};
}@end

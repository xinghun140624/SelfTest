//
//  HCUserMemberModel.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserMemberModel.h"
@implementation HCUserMemberModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"userMemberId":@"id"};
}
@end

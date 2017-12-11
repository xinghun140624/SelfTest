
//
//  HCVipBirthdayApi.m
//  HongCai
//
//  Created by hoolai on 2017/12/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCVipBirthdayApi.h"

@implementation HCVipBirthdayApi
{
    int _userId;
}
- (instancetype)initWithUserId:(int)userId{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"userId":@(_userId)};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/users/member/userMemberBirthdayIndexShow";
}
@end

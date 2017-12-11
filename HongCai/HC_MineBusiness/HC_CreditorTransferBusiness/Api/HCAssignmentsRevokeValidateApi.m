//
//  HCAssignmentsRevokeValidateApi.m
//  HongCai
//
//  Created by Candy on 2017/7/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAssignmentsRevokeValidateApi.h"

@implementation HCAssignmentsRevokeValidateApi
{
    NSDictionary *_params;
}
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _params = params;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return _params;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    if (_params) {
        return [NSString stringWithFormat:@"rest/users/0/assignments/%@/revokeValidate",_params[@"number"]];
    }
    return @"";
}
@end

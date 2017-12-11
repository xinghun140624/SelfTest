//
//  HCAssignmentsCancelApi.m
//  HongCai
//
//  Created by Candy on 2017/7/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAssignmentsCancelApi.h"

@implementation HCAssignmentsCancelApi
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
    return YTKRequestMethodDELETE;
}
- (NSString *)requestUrl {
    if (_params) {
        return [NSString stringWithFormat:@"rest/users/0/assignments/%@",_params[@"number"]];
    }
    return @"";
}
@end

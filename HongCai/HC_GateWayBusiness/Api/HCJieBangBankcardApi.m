//
//  HCJieBangBankcardApi.m
//  Pods
//
//  Created by Candy on 2017/7/12.
//
//

#import "HCJieBangBankcardApi.h"

@implementation HCJieBangBankcardApi
{
    NSDictionary *_params;
}
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _params = params;
    }
    return self;
}

- (id)requestArgument {
    return _params;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/bankcard";
}
@end

//
//  HCInvestcreastRateCouponApi.m
//  Pods
//
//  Created by Candy on 2017/6/29.
//
//

#import "HCInvestIncreastRateCouponApi.h"

@implementation HCInvestIncreastRateCouponApi
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
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    if (_params) {
        return [NSString stringWithFormat:@"rest/users/0/coupons/projects/%@",_params[@"number"]];
    }
    return @"";
}
@end

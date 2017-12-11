//
//  HCUserCouponsStatApi.m
//  HongCai
//
//  Created by Candy on 2017/7/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserCouponsStatApi.h"

@implementation HCUserCouponsStatApi
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
- (NSString *)requestUrl {
    return @"rest/users/0/coupons/stat";
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end

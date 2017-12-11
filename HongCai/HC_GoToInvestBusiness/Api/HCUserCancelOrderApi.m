//
//  HCUserCancelOrderApi.m
//  HC_GoToInvestBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserCancelOrderApi.h"

@implementation HCUserCancelOrderApi
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
    return YTKRequestMethodDELETE;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/orders/cancel";
}
@end

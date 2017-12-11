//
//  HCPayMentApi.m
//  HC_GateWayBusiness
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCPayMentApi.h"

@implementation HCPayMentApi
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
- (id)requestArgument {
    return _params;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    if (_params) {
        return [NSString stringWithFormat:@"rest/orders/%@/users/0/payment",_params[@"orderNumber"]];
    }
    return @"";
}
@end

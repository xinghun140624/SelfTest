//
//  HCGetUserBalanceApi.m
//  HongCai
//
//  Created by Candy on 2017/6/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGetUserBalanceApi.h"

@implementation HCGetUserBalanceApi
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
    return YTKRequestMethodGET;
}


- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/accounts/0/balance";
}
@end

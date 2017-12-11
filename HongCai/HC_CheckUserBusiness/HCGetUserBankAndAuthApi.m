//
//  HCGetUserBankAndAuthApi.m
//  HongCai
//
//  Created by Candy on 2017/7/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGetUserBankAndAuthApi.h"

@implementation HCGetUserBankAndAuthApi
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
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (NSString *)requestUrl {
    return @"rest/users/0/status";
}
@end

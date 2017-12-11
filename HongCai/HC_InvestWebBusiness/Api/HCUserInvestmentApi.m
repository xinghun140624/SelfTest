//
//  HCUserInvestmentApi.m
//  HC_WebBusiness
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserInvestmentApi.h"

@implementation HCUserInvestmentApi
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
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (NSString *)requestUrl {
    if (_params) {
        return [NSString stringWithFormat:@"rest/projects/%@/users/0/investment",_params[@"projectNumber"]];
    }
    return @"";
}
@end

//
//  HCMyInvestCreditDetailApi.m
//  HongCai
//
//  Created by Candy on 2017/7/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyInvestCreditDetailApi.h"

@implementation HCMyInvestCreditDetailApi
{
    NSDictionary *_params;
}
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _params = params;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/creditRights/0/creditDetail";
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return _params;
}
@end

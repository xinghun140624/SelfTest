//
//  HCMyInvestApi.m
//  Pods
//
//  Created by Candy on 2017/7/10.
//
//

#import "HCMyInvestApi.h"

@implementation HCMyInvestApi
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
    return @"rest/users/0/creditRights";
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

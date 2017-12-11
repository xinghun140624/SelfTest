//
//  HCUserDisabledAutoTenderApi.m
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserDisabledAutoTenderApi.h"

@implementation HCUserDisabledAutoTenderApi
{
    NSDictionary * _params;
}
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self= [super init]) {
        _params = params;
    }
    return self;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPUT;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version": @"2.0.0"};
}
- (id)requestArgument {
    return _params;
}
- (NSString *)requestUrl {
    return @"rest/users/0/disabledAutoTender";
}
@end

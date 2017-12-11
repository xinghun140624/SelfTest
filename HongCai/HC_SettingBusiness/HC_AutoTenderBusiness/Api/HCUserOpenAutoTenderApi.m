//
//  HCUserOpenAutoTenderApi.m
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserOpenAutoTenderApi.h"

@implementation HCUserOpenAutoTenderApi
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
    return YTKRequestMethodPOST;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version": @"2.0.0"};
}
- (id)requestArgument {
    return _params;
}
- (NSString *)requestUrl {
    return @"rest/autoTenders";
}
@end

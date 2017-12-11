//
//  HCGetUserBankCardApi.m
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGetUserBankCardApi.h"

@implementation HCGetUserBankCardApi
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
    return YTKRequestMethodGET;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version": @"2.0.0"};
}
- (id)requestArgument {
    return _params;
}
- (NSString *)requestUrl {
    return @"rest/users/0/bankcard";
}
@end

//
//  HCUserAuthApi.m
//  HongCai
//
//  Created by Candy on 2017/6/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserAuthApi.h"

@implementation HCUserAuthApi
{
    NSString * _token;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
        NSAssert(_token, @"token参数不能为空");
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"token":_token};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/users/0/userAuth";
}

@end

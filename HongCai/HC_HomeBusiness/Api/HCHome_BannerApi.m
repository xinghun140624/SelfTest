//
//  HCHome_BannerApi.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCHome_BannerApi.h"

@implementation HCHome_BannerApi
{
    NSString * _token;
    NSInteger _type;
}
- (instancetype)initWithToken:(NSString *)token type:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
        _token = token;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    if (_token) {
        return @{@"token":_token,@"type":@(_type)};
    }
    return @{@"type":@(_type)};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/banners";
}
@end

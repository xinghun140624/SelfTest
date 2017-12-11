//
//  HCBannerActivityApi.m
//  HongCai
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCBannerActivityApi.h"

@implementation HCBannerActivityApi
{
    NSString *_token;
    NSInteger _type;
    NSInteger _locale;
    NSInteger _count;
}
- (instancetype)initWithToken:(NSString *)token type:(NSInteger)type locale:(NSInteger)locale count:(NSInteger)count {
    if (self = [super init]) {
        _token = token;
        _type = type;
        _locale = locale;
        _count = count;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    if (_token) {
        return @{@"token":_token,@"type":@(_type),@"locale":@(_locale),@"count":@(_count)};
    }
    return @{@"type":@(_type),@"locale":@(_locale),@"count":@(_count)};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/banners/activity";
}
@end

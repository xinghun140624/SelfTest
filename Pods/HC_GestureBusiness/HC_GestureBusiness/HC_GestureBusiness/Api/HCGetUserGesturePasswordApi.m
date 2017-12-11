//
//  HCGetUserGesturePasswordApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGetUserGesturePasswordApi.h"

@implementation HCGetUserGesturePasswordApi
{
    NSString * _token;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
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
    return @"rest/users/0/passwords/gesture";
}

@end

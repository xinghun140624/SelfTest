//
//  HCShowNewUserFloatApi.m
//  HongCai
//
//  Created by Candy on 2017/7/31.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCShowNewUserFloatApi.h"

@implementation HCShowNewUserFloatApi
{
    NSString *_token;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
        NSAssert(token, @"token不能为空");
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"token":_token};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/activitys/showNewUserFloat";
}
@end

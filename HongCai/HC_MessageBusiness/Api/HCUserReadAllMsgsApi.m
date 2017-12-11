//
//  HCUserReadAllMsgsApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/9/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserReadAllMsgsApi.h"

@implementation HCUserReadAllMsgsApi
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

- (id)requestArgument {
    return @{@"token":_token};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPUT;
}
- (NSString *)requestUrl {
    return @"rest/userMsgs/0/readAllUserMsgs";
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end

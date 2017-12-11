//
//  HCUserUnReadNoticesApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/9/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserUnReadNoticesApi.h"

@implementation HCUserUnReadNoticesApi
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
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/userMsgs/0/unReadNotices";
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end

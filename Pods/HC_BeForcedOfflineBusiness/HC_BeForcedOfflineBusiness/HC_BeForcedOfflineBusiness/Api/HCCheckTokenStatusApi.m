//
//  HCCheckTokenStatusApi.m
//  HC_BeForcedOfflineBusiness
//
//  Created by 郭金山 on 2017/9/14.
//  Copyright © 2017年 candy. All rights reserved.
//

#import "HCCheckTokenStatusApi.h"

@implementation HCCheckTokenStatusApi
{
    NSString * _token;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token =  token;
        NSAssert(_token, @"token不能为空");
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (NSString *)requestUrl {
 return @"rest/users/0/token/status";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return  YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return @{@"token":_token};
}
@end

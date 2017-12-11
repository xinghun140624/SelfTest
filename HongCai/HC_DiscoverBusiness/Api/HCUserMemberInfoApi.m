//
//  HCUserMemberInfoApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserMemberInfoApi.h"

@implementation HCUserMemberInfoApi
{
    NSString *_token;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
        NSAssert(_token, @"token不能为空");
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
    return @"rest/users/member/memberInfo";
}
@end

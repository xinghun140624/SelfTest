//
//  HCMemberWelfaresApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberWelfaresTypeApi.h"

@implementation HCMemberWelfaresTypeApi
{
    NSString *_token;
    NSInteger _level;
}

- (instancetype)initWithToken:(NSString *)token level:(NSInteger)level {
    if (self = [super init]) {
        _token = token;
        _level = level;
        NSAssert(_token, @"token不能为空");
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"token":_token,@"level":@(_level)};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/users/member/welfareTypes";
}
@end

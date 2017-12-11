//
//  HCMemberWelfareApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberWelfareApi.h"

@implementation HCMemberWelfareApi
{
    NSString * _token;
    NSInteger _userId;
    NSInteger _memberWelfareId;
    NSInteger _number;
}
- (instancetype)initWithToken:(NSString *)token userId:(NSInteger)userId memberWelfareId:(NSInteger)memberWelfareId number:(NSInteger)number
{
    
    if (self = [super init]) {
        _token = token;
        _userId = userId;
        _memberWelfareId = memberWelfareId;
        _number = number;
        NSAssert(_token, @"token不能为空");
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"token":_token,@"userId":@(_userId),@"memberWelfareId":@(_memberWelfareId),@"number":@(_number)};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/users/member/welfare";
}
@end

//
//  HCModifyPasswordApi.m
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import "HCModifyPasswordApi.h"

@implementation HCModifyPasswordApi
{
    NSString * _token;
    NSString *_oldPassword;
    NSString *_newPassword;
}
- (instancetype)initWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword token:(NSString *)token {
    if (self = [super init]) {
        _token = token;
        _newPassword = newPassword;
        _oldPassword = oldPassword;
        NSAssert(_token, @"token 不能为空");
        NSAssert(_newPassword, @"新密码 不能为空");
        NSAssert(_oldPassword, @"旧密码 不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/0/passwords";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPUT;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"token":_token,@"oldPassword":_oldPassword,@"newPassword":_newPassword};
}
@end

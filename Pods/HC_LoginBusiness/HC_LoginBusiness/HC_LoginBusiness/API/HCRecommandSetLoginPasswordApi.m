//
//  HCRecommandSetLoginPasswordApi.m
//  Pods
//
//  Created by Candy on 2017/7/19.
//
//

#import "HCRecommandSetLoginPasswordApi.h"

@implementation HCRecommandSetLoginPasswordApi
{
    NSString * _token;
    NSString *_password;
}
- (instancetype)initWithToken:(NSString *)token password:(NSString *)password {
    if (self = [super init]) {
        _token = token;
        _password = password;
        NSAssert(_token, @"token 不能为空");
        NSAssert(_password, @"password 不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/0/passwords";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"token":_token,@"password":_password};
}
@end

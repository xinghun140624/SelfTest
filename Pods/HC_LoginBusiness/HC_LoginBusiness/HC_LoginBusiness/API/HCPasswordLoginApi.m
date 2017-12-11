//
//  HCPasswordLoginApi.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCPasswordLoginApi.h"

@implementation HCPasswordLoginApi
{
    NSString * _account;
    NSString * _password;
}
- (instancetype)initWithAccount:(NSString *)account password:(NSString *)password {
    if (self = [super init]) {
        _account = account;
        _password = password;
        NSAssert(_account, @"账号不能为空");
        NSAssert(_password, @"密码不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/login";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"account":_account,@"password":_password};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end

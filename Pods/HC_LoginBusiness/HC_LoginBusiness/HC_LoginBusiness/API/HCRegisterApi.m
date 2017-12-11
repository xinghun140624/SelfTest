//
//  HCRegisterApi.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRegisterApi.h"

@implementation HCRegisterApi
{
    NSString * _mobile;
    NSString * _captcha;
    NSString * _password;
}
- (instancetype)initWithMobile:(NSString *)mobile captcha:(NSString *)captcha password:(NSString *)password {
    if (self = [super init]) {
        _mobile = mobile;
        _captcha = captcha;
        _password = password;
        NSAssert(_mobile, @"手机号 不能为空");
        NSAssert(_captcha, @"图形验证码不能为空");
        NSAssert(_password, @"密码不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/register";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"mobile":_mobile,@"captcha":_captcha,@"password":_password};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end

//
//  HCCodeLoginApi.m
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCodeLoginApi.h"

@implementation HCCodeLoginApi
{
    NSString *_mobile;
    NSString *_captcha;
}
- (instancetype)initWithMobile:(NSString *)mobile captcha:(NSString *)captcha {
    if (self = [super init]) {
        _mobile = mobile;
        _captcha = captcha;
        NSAssert(_mobile, @"手机号不能为空");
        NSAssert(_captcha, @"验证码不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/mobileLogin";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"mobile":_mobile,@"captcha":_captcha};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end

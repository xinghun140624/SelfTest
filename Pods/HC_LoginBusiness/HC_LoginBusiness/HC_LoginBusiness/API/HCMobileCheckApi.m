//
//  HCMobileCheckApi.m
//  Pods
//
//  Created by Candy on 2017/7/5.
//
//

#import "HCMobileCheckApi.h"

@implementation HCMobileCheckApi
{
    int _business;
    NSString *_mobile;
    NSString *_captcha;
    int _type;
}

- (instancetype)initWithBusiness:(int)business mobile:(NSString *)mobile captcha:(NSString *)captcha type:(int)type {
    if (self = [super init]) {
        _business = business;
        _mobile = mobile;
        _captcha = captcha;
        _type = type;
        NSAssert(_mobile, @"手机号不能为空");
        NSAssert(_captcha, @"验证码不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"rest/captchas/%@/check",_mobile];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"business":@(_business),@"mobile":_mobile,@"type":@(_type),@"captcha":_captcha};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end

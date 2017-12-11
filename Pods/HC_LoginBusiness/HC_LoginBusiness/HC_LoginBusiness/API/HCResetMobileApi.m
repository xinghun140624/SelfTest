//
//  HCResetMobileApi.m
//  Pods
//
//  Created by Candy on 2017/7/5.
//
//

#import "HCResetMobileApi.h"

@implementation HCResetMobileApi
{
    NSString *_mobile;
    NSString *_captcha;
}
- (instancetype)initWithMobile:(NSString *)mobile captcha:(NSString *)captcha {
    if (self = [super init]) {
        _mobile = mobile;
        _captcha = captcha;
        NSAssert(_mobile, @"手机号 不能为空");
        NSAssert(_captcha, @"图形验证码不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/0/resetMobile";
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

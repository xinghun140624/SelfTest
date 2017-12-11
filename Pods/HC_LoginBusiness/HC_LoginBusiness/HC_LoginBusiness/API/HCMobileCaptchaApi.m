//
//  HCMobileCaptchaApi.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMobileCaptchaApi.h"

@implementation HCMobileCaptchaApi
{
    int _business;
    NSString *_mobile;
    NSString *_picCaptcha;
    int _type;
}
- (instancetype)initWithBusiness:(int)business mobile:(NSString *)mobile picCaptcha:(NSString *)picCaptcha type:(int)type {
    if (self = [super init]) {
        _business = business;
        _mobile = mobile;
        _picCaptcha = picCaptcha;
        _type = type;
        NSAssert(_mobile, @"手机号不能为空");
        NSAssert(_picCaptcha, @"验证码不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/mobileCaptcha";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"type":@(_type),@"business":@(_business),@"mobile":_mobile,@"picCaptcha":_picCaptcha};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end


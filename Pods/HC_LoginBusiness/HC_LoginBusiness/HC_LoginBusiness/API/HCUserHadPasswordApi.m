//
//  HCUserHadPasswordApi.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserHadPasswordApi.h"

@implementation HCUserHadPasswordApi
{
    NSString * _mobile;
}
- (instancetype)initWithMobile:(NSString *)mobile {
    if (self = [super init]) {
        _mobile = mobile;
        NSAssert(_mobile, @"手机号不能为空");
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/users/0/passwords/hadPassword";
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"mobile":_mobile};
}
@end

//
//  HCCaptchasApi.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCaptchasApi.h"

@implementation HCCaptchasApi
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/captchas";
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end

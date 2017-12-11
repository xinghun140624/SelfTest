//
//  HCSystemVersionApi.m
//  HongCai
//
//  Created by Candy on 2017/8/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSystemVersionApi.h"

@implementation HCSystemVersionApi
{
    NSString *_os;
    NSString *_appVersion;
}
- (instancetype)initWithOs:(NSString *)os appVersion:(NSString *)appVersion {
    if (self=  [super init]) {
        _os = os;
        _appVersion = appVersion;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"os":_os,@"appVersion":_appVersion};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/appVersions/latestVersion";
}
@end

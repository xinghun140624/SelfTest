//
//  HCAdApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAdApi.h"

@implementation HCAdApi
{
    NSDictionary *_params;
}
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        _params = params;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return _params;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/activitys/adBanner";
}
@end

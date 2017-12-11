//
//  HCUserRecentlyQuestionApi.m
//  HongCai
//
//  Created by Candy on 2017/7/18.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserRecentlyQuestionApi.h"

@implementation HCUserRecentlyQuestionApi
{
    NSDictionary * _params;
}
- (instancetype)initWithParams:(NSDictionary *)params {
    if (self= [super init]) {
        _params = params;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return _params;
}
- (NSString *)requestUrl {
    return @"rest/users/0/recentlyQuestionnaire";
}
@end

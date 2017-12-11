//
//  HCAssignmentRuleApi.m
//  HongCai
//
//  Created by Candy on 2017/7/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAssignmentRuleApi.h"

@implementation HCAssignmentRuleApi
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
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument {
    return _params;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    
    return @"rest/assignments/assignmentRule";
}
@end

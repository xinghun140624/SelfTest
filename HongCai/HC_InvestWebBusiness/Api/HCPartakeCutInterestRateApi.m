//
//  HCPartakeCutInterestRateApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCPartakeCutInterestRateApi.h"

@implementation HCPartakeCutInterestRateApi {
    NSString * _token;
    int  _projectType;
}

- (instancetype)initWithProjectType:(int)projectType token:(NSString *)token {
    if (self = [super init]) {
        _token = token;
        _projectType = projectType;
    }
    return self;
}

- (id)requestArgument {
    return @{@"token":_token};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (NSString *)requestUrl {
    NSAssert(_projectType, @"项目类型不能为空");
    NSString * requestUrl = [NSString stringWithFormat:@"rest/projects/%d/partakeCutInterestRate",_projectType];
    return  requestUrl;
}
@end

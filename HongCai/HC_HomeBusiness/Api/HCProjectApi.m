//
//  HCProjectApi.m
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCProjectApi.h"

@implementation HCProjectApi
{
    NSInteger _page;
    NSInteger _pageSize;
    NSInteger _type;
}
- (instancetype)initWithPage:(NSInteger)page pageSize:(NSInteger)pageSize type:(NSInteger)type{
    if (self = [super init]) {
        _page = page;
        _pageSize = pageSize;
        _type = type;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"page":@(_page),@"pageSize":@(_pageSize),@"type":@(_type)};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/projects";
}
@end

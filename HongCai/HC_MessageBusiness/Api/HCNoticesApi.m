//
//  HCNoticesApi.m
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCNoticesApi.h"

@implementation HCNoticesApi
{
    NSInteger _page;
    NSInteger _pageSize;
}
- (instancetype)initWithPage:(NSInteger)page pageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _page = page;
        _pageSize = pageSize;
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
    return @{@"page":@(_page),@"pageSize":@(_pageSize)};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/userMsgs/0/notices";
}
@end

//
//  HCInvestProfitDealsApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/9/13.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInvestProfitDealsApi.h"

@implementation HCInvestProfitDealsApi
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
    return @"rest/users/0/deals/investProfitDeals";
}
@end

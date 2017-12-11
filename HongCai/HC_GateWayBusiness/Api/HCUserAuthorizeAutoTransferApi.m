//
//  HCUserAuthorizeAutoTransferApi.m
//  HongCai
//
//  Created by Candy on 2017/7/31.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserAuthorizeAutoTransferApi.h"

@implementation HCUserAuthorizeAutoTransferApi
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
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/users/0/authorizeAutoTransfer";
}
@end

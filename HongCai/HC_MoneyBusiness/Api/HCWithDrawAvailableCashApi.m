//
//  HCWithDrawAvailableCashApi.m
//  HongCai
//
//  Created by Candy on 2017/11/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCWithDrawAvailableCashApi.h"

@implementation HCWithDrawAvailableCashApi
{
    NSString * _token;
    NSInteger _userId;
}
- (instancetype)initWithToken:(NSString *)token userId:(NSInteger)userId {
    if (self = [super init]) {
        _token = token;
        _userId = userId;
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
    return @{@"token":_token,@"userId":@(_userId)};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (NSString *)requestUrl {
    return @"rest/users/0/availableCash";
}
@end

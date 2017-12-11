//
//  HCCalendarRepaymentDetailsApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCalendarRepaymentDetailsApi.h"

@implementation HCCalendarRepaymentDetailsApi
{
    NSString * _token;
    int _userId;
    int _type;
    NSTimeInterval _startTime;
    NSTimeInterval _endTime;
    
}
- (instancetype)initWithToken:(NSString *)token userId:(int)userId type:(int)type startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime {
    if (self = [super init]) {
        _token = token;
        _type = type;
        _startTime = startTime;
        _endTime = endTime;
    }
    return self;
}
- (id)requestArgument {
    return @{@"token":_token,@"userId":@(_userId),@"type":@(_type),@"startTime":@(_startTime),@"endTime":@(_endTime)};
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
    return @"rest/projectFullBills/repaymentDetails";
}
@end

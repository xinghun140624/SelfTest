//
//  HCGetCalendarDataApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGetCalendarDataApi.h"

@implementation HCGetCalendarDataApi
{
    NSString *_token;
    int _userId;
    NSTimeInterval _startTime;
    NSTimeInterval _endTime;
    
}
- (instancetype)initWithToken:(NSString *)token userId:(int)userId startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime {
    if (self = [super init]) {
        _token = token;
        _userId = userId;
        _startTime = startTime;
        _endTime = endTime;
        NSAssert(token, @"token不能为空");
        NSAssert(userId, @"userId不能为空，并且不能为0");
    }
    return self;
}

- (id)requestArgument {
    return @{@"token":_token,@"userId":@(_userId),@"startTime":@(_startTime),@"endTime":@(_endTime)};
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
    return @"rest/projectFullBills/calendarData";
}
@end

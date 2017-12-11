//
//  HCUpdateUserGesturePasswordApi.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUpdateUserGesturePasswordApi.h"

@implementation HCUpdateUserGesturePasswordApi
{
    NSString * _gesture;
    NSString * _token;
}
- (instancetype)initWithGesture:(NSString * )gesture token:(NSString *)token {
    
  if (self = [super init]) {
      _gesture = gesture;
      _token = token;
    }
    return self;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
- (id)requestArgument {
    return @{@"token":_token,@"gesture":_gesture};
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSString *)requestUrl {
    return @"rest/users/0/passwords/gesture";
}
@end

//
//  HCUserIsUniqueApi.m
//  HC_LoginBusiness
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCUserIsUniqueApi.h"

@implementation HCUserIsUniqueApi
{
    NSString *_account;
}
- (instancetype)initWithAccount:(NSString *)account{
    if (self = [super init]) {
        _account = account;
        NSAssert(_account, @"账号不能为空");
    }
    return self;
}
- (NSString *)requestUrl {
    return @"rest/users/isUnique";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"version":@"2.0.0"};
}
-(id)requestArgument {
    return @{@"account":_account};
}
@end

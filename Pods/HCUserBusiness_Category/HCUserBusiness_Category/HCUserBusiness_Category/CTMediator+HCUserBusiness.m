//
//  CTMediator+HCUserBusiness.m
//  HCUserBusiness_Category
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCUserBusiness.h"

@implementation CTMediator (HCUserBusiness)
- (NSDictionary *)HCUserBusiness_getUser {
    return [self performTarget:@"HCUserBusiness" action:@"getUser" params:nil shouldCacheTarget:YES];
}
- (BOOL)HCUserBusiness_saveUser:(NSDictionary *)params {
    if (!params) {
        NSAssert(params, @"不能保存空数据");
        return NO;
    }
    return [self performTarget:@"HCUserBusiness" action:@"saveUser" params:params shouldCacheTarget:NO];
}
- (BOOL)HCUserBusiness_removeUser {
    return [self performTarget:@"HCUserBusiness" action:@"removeUser" params:nil shouldCacheTarget:NO];
}

- (void)HCUserBusiness_getUserAuth:(NSDictionary *)param SuccessCallBack:(void(^)(NSDictionary * info))successCallBack {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (successCallBack) {
        params[@"successCallBack"] = successCallBack;
        params[@"token"] = param[@"token"];
    }
    [self performTarget:@"HCUserBusiness" action:@"getUserAuth" params:params shouldCacheTarget:YES];
}
@end

//
//  Target_HCUserBusiness.m
//  HC_UserBusiness
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCUserBusiness.h"
#import "HCUser.h"
#import "HCUserAuthApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>


typedef void(^successCallBack)(NSDictionary * info);

@implementation Target_HCUserBusiness
- (NSDictionary *)Action_getUser:(NSDictionary *)params {
    HCUser * user = [HCUserService user];
    if (user) {
        return [user yy_modelToJSONObject];
    }
    return nil;
}
- (BOOL)Action_saveUser:(NSDictionary *)params {
    HCUser *user =  [HCUser yy_modelWithJSON:params];
    return @([HCUserService saveUser:user]);
}
- (BOOL)Action_removeUser:(NSDictionary *)params {
    return @([HCUserService removeUser]);
}
- (void)Action_getUserAuth:(NSDictionary *)params {
    HCUserAuthApi * userApi = [[HCUserAuthApi alloc] initWithToken:params[@"token"]];
    [userApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        successCallBack callBack = params[@"successCallBack"];
        if (callBack && request.responseJSONObject) {
            callBack(request.responseJSONObject);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];

}
@end

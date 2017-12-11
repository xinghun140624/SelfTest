//
//  HCMeService.m
//  HongCai
//
//  Created by Candy on 2017/7/6.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMeService.h"
#import "HCAccountApi.h"
#import "HCUserCouponsStatApi.h"
#import "HCUserUnReadMsgsApi.h"
#import "HCUserUnReadNoticesApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>

@implementation HCMeService
/**
 获得用户信息
 */
+ (void)getUserAccountInformationWithToken:(NSString *)token success:(void(^)(HCAccountModel *model))accountModel {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"token"] = token;
        HCAccountApi * api = [[HCAccountApi alloc] initWithParams:params];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (request.responseJSONObject) {
                
                HCAccountModel * model = [HCAccountModel yy_modelWithJSON:request.responseJSONObject];
                if (accountModel) {
                    accountModel(model);
                }

            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD showText:request.error.localizedDescription];
        }];
}
+ (void)getUserCouponStatWithToken:(NSString *)token success:(void(^)(NSInteger unUsedCouponCount))success {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    HCUserCouponsStatApi * api = [[HCUserCouponsStatApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (request.responseJSONObject && success ) {
            success([request.responseJSONObject[@"unUsedCoupon"] integerValue]);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD showText:request.error.localizedDescription];
    }];
}
+ (void)getUserUnReadMsgsWithToken:(NSString *)token success:(void(^)(BOOL isHaveUnReadCount))success {
    
    HCUserUnReadMsgsApi * userUnReadMsgsApi = [[HCUserUnReadMsgsApi alloc] initWithToken:token];
    HCUserUnReadNoticesApi  * userUnReadNoticesApi = [[HCUserUnReadNoticesApi alloc] initWithToken:token];
    
    
    YTKBatchRequest * request = [[YTKBatchRequest alloc] initWithRequestArray:@[userUnReadNoticesApi,userUnReadMsgsApi]];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        
        HCUserUnReadNoticesApi * api1 = (HCUserUnReadNoticesApi *)batchRequest.requestArray.firstObject;
        BOOL isHaveUnReadNotices = NO;
        if (api1.responseObject) {
            NSInteger count = [api1.responseObject[@"count"] integerValue];
            if (count>0) {
                isHaveUnReadNotices = YES;
            }
        }
        
        HCUserUnReadMsgsApi * api2 = (HCUserUnReadMsgsApi *)batchRequest.requestArray.lastObject;
        BOOL isHaveUnReadMsgs = NO;
        if (api2.responseObject) {
            NSInteger count = [api2.responseObject[@"count"] integerValue];
            if (count>0) {
                isHaveUnReadMsgs = YES;
            }
        }
        if (success &&(isHaveUnReadNotices || isHaveUnReadMsgs)) {
            success(YES);
        }else{
            success(NO);
        }
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        if (success) {
            success(NO);
        }
        if (batchRequest.failedRequest.responseJSONObject) {
           [MBProgressHUD showText:batchRequest.failedRequest.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:batchRequest.failedRequest.error.localizedDescription];
        }
    }];
    

}
@end

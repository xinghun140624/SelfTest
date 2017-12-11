//
//  HCRechargeService.m
//  HongCai
//
//  Created by Candy on 2017/7/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMoneyService.h"
#import "HCGetUserBalanceApi.h"
#import "HCGetUserBankCardApi.h"
#import "HCUserRechargeBankLimitApi.h"
#import "HCWithDrawAvailableCashApi.h"
#import "HCWithDrawFreeCountApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>

@implementation HCMoneyService
+ (void)getRechargeData:(void(^)(NSDecimalNumber *balance,HCUserBankCardModel * model,NSDictionary *bankLimitData))data errorMessage:(void(^)(NSString *errorMessage))errorMessage {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];

    HCGetUserBalanceApi * userBalanceApi = [[HCGetUserBalanceApi alloc] initWithParams:params];
    HCGetUserBankCardApi * userBankApi = [[HCGetUserBankCardApi alloc] initWithParams:params];
    HCUserRechargeBankLimitApi * bankLimitApi = [[HCUserRechargeBankLimitApi alloc] initWithParams:params];

    YTKBatchRequest * request = [[YTKBatchRequest alloc] initWithRequestArray:@[userBalanceApi,userBankApi,bankLimitApi]];
    [request startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        HCGetUserBalanceApi * userBalanceApi = (HCGetUserBalanceApi *)batchRequest.requestArray[0];
        NSDecimalNumber * balance = userBalanceApi.responseJSONObject[@"balance"];
        HCGetUserBankCardApi * userBankApi = (HCGetUserBankCardApi *)batchRequest.requestArray[1];
        HCUserBankCardModel * model = [HCUserBankCardModel yy_modelWithJSON:userBankApi.responseObject];
        
        HCUserRechargeBankLimitApi * bankLimitApi = (HCUserRechargeBankLimitApi *)batchRequest.requestArray[2];
        NSDictionary * bankLimitData = bankLimitApi.responseObject;
        
        if (data) {
            data(balance,model,bankLimitData);
        }
        
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        
        if (errorMessage) {
            if (batchRequest.failedRequest.responseJSONObject) {
                errorMessage(batchRequest.failedRequest.responseJSONObject[@"msg"]);
            }else{
                errorMessage(batchRequest.failedRequest.error.localizedDescription);
            }
        }
        
    }];
}
+ (void)getAvailableCashData:(void(^)(HCWithDrawModel * withDrawmodel,NSDictionary *freeCount))withDrawmodel  errorMessage:(void(^)(NSString *errorMessage))errorMessage {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];

    HCWithDrawAvailableCashApi * api = [[HCWithDrawAvailableCashApi alloc] initWithToken:user[@"token"] userId:[user[@"id"] integerValue]];
    HCWithDrawFreeCountApi * freeApi = [[HCWithDrawFreeCountApi alloc] initWithToken:user[@"token"] userId:[user[@"id"] integerValue]];
    YTKBatchRequest * request = [[YTKBatchRequest alloc] initWithRequestArray:@[api,freeApi]];
    [request startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        HCWithDrawAvailableCashApi * cashApi =(HCWithDrawAvailableCashApi *)batchRequest.requestArray.firstObject;
        HCWithDrawFreeCountApi * freeApi =(HCWithDrawFreeCountApi *)batchRequest.requestArray.lastObject;

        if (cashApi.responseJSONObject && freeApi.responseObject) {
            HCWithDrawModel * model = [HCWithDrawModel yy_modelWithJSON:cashApi.responseJSONObject];
            NSDictionary * freeCount = freeApi.responseObject;
            
            withDrawmodel(model,freeCount);
        }
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        if (batchRequest.failedRequest.responseObject) {
            errorMessage(batchRequest.failedRequest.responseJSONObject[@"msg"]);
        }else {
            errorMessage(batchRequest.failedRequest.error.localizedDescription);
        }
    }];


}
@end

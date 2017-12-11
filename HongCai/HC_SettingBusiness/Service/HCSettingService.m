//
//  HCSettingService.m
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSettingService.h"
#import "HCGetUserBankCardApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCUserRecentlyQuestionApi.h"
#import "HCUserGetAutoTenderApi.h"

@implementation HCSettingService
+ (void)getUserBankCardWithToken:(NSString *)token success:(void(^)(HCUserBankCardModel *model))success {
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    HCGetUserBankCardApi * api = [[HCGetUserBankCardApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            HCUserBankCardModel * model = [HCUserBankCardModel yy_modelWithJSON:request.responseJSONObject];
            if (success) {
                success(model);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
            
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];

        }
    }];
}
+ (void)getUserQuestionWithToken:(NSString *)token success:(void(^)(NSString *desc))success {

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    HCUserRecentlyQuestionApi * api = [[HCUserRecentlyQuestionApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            NSInteger score = [request.responseJSONObject[@"score2"] integerValue];
            NSString * string = @"";
            if (score == -1) {
                success(@"去测评");
                return;
            }
            if (score<35) {
                string = @"保守型";
            }else if (score>=35&&score<=59) {
                string = @"稳健型";
            }else if (score>59) {
                string = @"进取型";
            }
            success(string);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(@"去测评");
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];

    
}

+ (void)getUserAutoTenderWithToken:(NSString *)token success:(void(^)(HCUserAutoTenderModel *model))success {

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    HCUserGetAutoTenderApi * api = [[HCUserGetAutoTenderApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            HCUserAutoTenderModel * model = [HCUserAutoTenderModel yy_modelWithJSON:request.responseObject];
            if (success) {
                success(model);
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
           
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];



}
@end

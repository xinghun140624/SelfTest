//
//  HCCreditorTransferService.m
//  HongCai
//
//  Created by Candy on 2017/7/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCreditorTransferService.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCCreditTransfer_AssignmentApi.h"
#import "HCMyInvestModel.h"

@implementation HCCreditorTransferService

+ (void)loadAssignmentRuleWithToken:(NSString *)token success:(void(^)(HCAssignmentRuleModel * model))success {
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = token;
    HCAssignmentRuleApi * api = [[HCAssignmentRuleApi alloc] initWithParams:param];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            HCAssignmentRuleModel * model = [HCAssignmentRuleModel yy_modelWithJSON:request.responseObject];
            if (success) {
                success(model);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        
    }];
    
}
+ (void)loadTransferableDataWithPage:(NSInteger )page success:(void(^)(NSArray *models,BOOL isFinish))success {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"pageSize"] = @(20);
        params[@"page"] = @(page);
        params[@"status"] = @(1);
        
        params[@"token"] = user[@"token"];
        HCCreditTransfer_TransferablesApi * api = [[HCCreditTransfer_TransferablesApi alloc] initWithParams:params];
        
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                NSArray * array = [NSArray yy_modelArrayWithClass:[HCMyInvestModel class] json:request.responseJSONObject[@"data"]];
                if (array.count) {
                    if (success) {
                        if (page== [request.responseJSONObject[@"totalPage"] integerValue]) {
                            success(array,YES);
                        }else{
                            success(array,NO);
                        }
                    }
                }else{
                    success(nil,YES);
                }
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (success) {
                success(nil,YES);
            }
            if (request.responseObject) {
                [MBProgressHUD showText:request.responseObject[@"msg"]];
            }else{
                [MBProgressHUD showText:request.error.localizedDescription];
            }
            
            
        }];
        
    }
}
+ (void)loadAssignmentTransferDataWithPage:(NSInteger )page types:(NSArray *)types success:(void(^)(NSArray *models,BOOL isFinish))success
{
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"pageSize"] = @(10);
        params[@"page"] = @(page);
        params[@"status"] =  [types componentsJoinedByString:@","];
        
        params[@"token"] = user[@"token"];
        HCCreditTransfer_AssignmentApi * api = [[HCCreditTransfer_AssignmentApi alloc] initWithParams:params];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                NSArray * array = [NSArray yy_modelArrayWithClass:[HCAssignmentModel class] json:request.responseJSONObject[@"data"]];
                if (array.count) {
                    if (success) {
                        if (page== [request.responseJSONObject[@"totalPage"] integerValue]) {
                            success(array,YES);
                        }else{
                            success(array,NO);
                        }
                    }
                }else{
                    success(nil,YES);
                }
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (request.responseObject) {
                [MBProgressHUD showText:request.responseObject[@"msg"]];
            }else{
                [MBProgressHUD showText:request.error.localizedDescription];
            }
            
        }];
        
    }
}
@end

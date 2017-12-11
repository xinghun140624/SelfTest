//
//  HCMyInvestService.m
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import "HCMyInvestService.h"
#import "HCMyInvestApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCMyInvestModel.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>


@implementation HCMyInvestService
+ (void)loadMyInvestDataWithPage:(NSInteger )page type:(NSInteger)type status:(NSInteger)status success:(void(^)(NSArray *models,BOOL isFinish))success {

    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"type"]  = @(type);
    params[@"status"]  = @(status);
    params[@"page"] = @(page);
    params[@"pageSize"] = @(5);
    HCMyInvestApi * api = [[HCMyInvestApi alloc] initWithParams:params];
    
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
@end

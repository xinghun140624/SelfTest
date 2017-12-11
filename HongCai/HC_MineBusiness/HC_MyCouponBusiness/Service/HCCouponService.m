//
//  HCCouponService.m
//  HongCai
//
//  Created by Candy on 2017/7/18.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCouponService.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCMyCouponModel.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCMyCouponApi.h"

@implementation HCCouponService

+ (void)getCouponsWithType:(NSInteger)type Page:(NSInteger)page status:(NSArray *)status success:(void(^)(NSArray * coupons,BOOL finished))coupons
{
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(page);
    if (type>0) {
        params[@"type"] = @(type);
    }
    params[@"pageSize"] = @(10);
    params[@"status"] = [status componentsJoinedByString:@","];
    params[@"token"] = user[@"token"];
    
    HCMyCouponApi * api = [[HCMyCouponApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[HCMyCouponModel class] json:request.responseJSONObject[@"data"]];
            if (array.count) {
                if (coupons) {
                    if (page== [request.responseJSONObject[@"totalPage"] integerValue]) {
                        coupons(array,YES);
                    }else{
                        coupons(array,NO);
                    }
                }
            }else{
                coupons(nil,YES);
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (coupons) {
            coupons(nil,YES);
        }
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        
        
    }];
 
}

@end

//
//  Target_HCGateWayBusiness.m
//  HC_GateWayBusiness
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "Target_HCGateWayBusiness.h"
#import "HCRechargeApi.h"
#import "HCYeePayRegisterApi.h"
#import "HCPayMentApi.h"
#import "HCWithdrawApi.h"
#import "HCBindBankcardApi.h"
#import "HCCgtActiveApi.h"
#import "HCJieBangBankcardApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCGateWaySuccessController.h"
#import "HCBankcardMobileApi.h"
#import "HCUserRechargeAuthTenderApi.h"
#import "HCResetPayPasswordApi.h"
#import "HCUserAuthorizeAutoTransferApi.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCNetworkConfig.h"
typedef void(^blockCallBack)(NSDictionary * info);

@implementation Target_HCGateWayBusiness
- (NSString *)urlEncodeUsingString:(NSString *)str
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)str,
                                                                                 NULL,
                                                                                 (CFStringRef)@":/?#[]@!$ &'()*+,;=<>%{}|\\^~`",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}
- (NSString *)paramsStingWithJSONObject:(id)responseJSONObject{

    NSString *reqData = [ self urlEncodeUsingString:responseJSONObject[@"reqData"]];
    NSString *sign = [ self urlEncodeUsingString:responseJSONObject[@"sign"]];
    NSString *paramSting =[NSString stringWithFormat:@"serviceName=%@&platformNo=%@&userDevice=%@&reqData=%@&keySerial=%@&sign=%@",responseJSONObject[@"serviceName"],responseJSONObject[@"platformNo"],@"MOBILE",reqData,responseJSONObject[@"keySerial"],sign];

    return paramSting;
}

- (void)handlerJumpWithUrl:(NSString *)url controller:(UIViewController *)controller title:(NSString *)title isContainsLimintAmountItem:(BOOL)isContains{
    
    NSString * webUrl = [NSString stringWithFormat:@"%@bha-neo-app/lanmaotech/gateway?%@",CGBaseURL,url];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[HCWebBusinessUrlKey] = webUrl;
    if (isContains) {
        params[HCNavigationItemKey] = @"限额";
    }
    UIViewController * webVC = [[CTMediator sharedInstance] HCWebBusiness_viewController:params];
    webVC.title = title;
    [controller.navigationController pushViewController:webVC animated:YES];
    
}
- (void)Action_yeePayRegister:(NSDictionary *)params {
    
    
    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    NSData *data = [params[@"realName"] dataUsingEncoding:NSUTF8StringEncoding];
    requestParams[@"realName"] =[[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    requestParams[@"from"] = @(4);
    requestParams[@"idCardNo"] = params[@"idCardNo"];
    requestParams[@"token"] = params[@"token"];
    HCYeePayRegisterApi * api = [[HCYeePayRegisterApi alloc] initWithParams:requestParams];
    
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:@"开通存管账户" isContainsLimintAmountItem:YES];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];
    
}

- (void)Action_payment:(NSDictionary *)params {
    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    requestParams[@"orderNumber"] = params[@"orderNumber"];
    requestParams[@"level"] = params[@"level"];

    HCPayMentApi * api = [[HCPayMentApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:nil isContainsLimintAmountItem:NO];
        }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];
}
- (void)Action_rechargeAndPayment:(NSDictionary *)params {

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    requestParams[@"investAmount"] = params[@"investAmount"];
    requestParams[@"projectNumber"] = params[@"projectNumber"];
    requestParams[@"couponNumber"] = params[@"couponNumber"];
    requestParams[@"level"] = params[@"level"];

 
    HCUserRechargeAuthTenderApi * api = [[HCUserRechargeAuthTenderApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];

        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:nil isContainsLimintAmountItem:NO];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];


}
- (void)Action_recharge:(NSDictionary *)params {

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    requestParams[@"amount"] = params[@"amount"];
    requestParams[@"rechargeWay"] = params[@"rechargeWay"];

    HCRechargeApi * api = [[HCRechargeApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];

        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:@"充值" isContainsLimintAmountItem:YES];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];
}

- (void)Action_withDraw:(NSDictionary *)params {

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    requestParams[@"amount"] = params[@"amount"];
    
    HCWithdrawApi * api = [[HCWithdrawApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];

        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:@"提现" isContainsLimintAmountItem:NO];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];
}

- (void)Action_bindBankcard:(NSDictionary *)params {

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    
    HCBindBankcardApi * api = [[HCBindBankcardApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:@"绑定银行卡" isContainsLimintAmountItem:YES];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];
}
- (void)Action_jieBangBankcard:(NSDictionary *)params {

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    
    HCJieBangBankcardApi * api = [[HCJieBangBankcardApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:@"解绑银行卡" isContainsLimintAmountItem:NO];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString delay:3];
    }];


}
- (void)Action_bankCardMobile:(NSDictionary *)params {

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    
    HCBankcardMobileApi * api = [[HCBankcardMobileApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        if ( request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:nil isContainsLimintAmountItem:NO];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];

    
    
}
- (void)Action_cgtActive:(NSDictionary *)params {

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    
    HCCgtActiveApi * api = [[HCCgtActiveApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        if ( request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:@"激活存管账户" isContainsLimintAmountItem:YES];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];
}
- (void)Action_resetPayPassword:(NSDictionary *)params {
    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    
    HCResetPayPasswordApi * api = [[HCResetPayPasswordApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        if (request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:nil isContainsLimintAmountItem:NO];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];


}
- (void)Action_userAuthorizeAutoTransfer:(NSDictionary *)params {
   

    NSMutableDictionary * requestParams = [NSMutableDictionary dictionary];
    requestParams[@"from"] = @(4);
    requestParams[@"token"] = params[@"token"];
    
    HCUserAuthorizeAutoTransferApi * api = [[HCUserAuthorizeAutoTransferApi alloc] initWithParams:requestParams];
    [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        if ( request.responseJSONObject) {
            UIViewController * controller = params[@"controller"];
            NSString * url = [self paramsStingWithJSONObject:request.responseObject];
            [self handlerJumpWithUrl:url controller:controller title:nil isContainsLimintAmountItem:NO];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
        NSString * errorString = nil;
        if (request.responseJSONObject) {
            errorString = request.responseJSONObject[@"msg"];
        }else{
            errorString = request.error.localizedDescription;
        }
        [MBProgressHUD showText:errorString];
    }];


}
- (UIViewController *)Action_successViewController:(NSDictionary *)params {
    HCGateWaySuccessController * successVC = [[HCGateWaySuccessController alloc] init];
    successVC.successParams = params;
    return successVC;
}

@end

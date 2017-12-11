//
//  HCCheckUserService.m
//  HongCai
//
//  Created by Candy on 2017/7/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCheckUserService.h"

#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <TYAlertController/TYAlertController.h>
#import "HCUserIdentityView.h"
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCGetUserBankAndAuthApi.h"//获取用户银行卡和授权状态
#import "HCCGActiveView.h"
#import "HCNetworkConfig.h"
@implementation HCCheckUserService



+ (void)checkUserAuthStatusAndBankcard:(UIViewController *)controller success:(void(^)(BOOL success))success {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = user[@"token"];
    
    HCGetUserBankAndAuthApi * api = [[HCGetUserBankAndAuthApi alloc] initWithParams:param];
    [MBProgressHUD showLoadingFromView:controller.view];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSNumber * auth = request.responseJSONObject[@"auth"];//0未认证，1 认证通过，2 未激活
        NSNumber * bankcard = request.responseJSONObject[@"bankcard"];//0 未绑卡 1 已绑卡
        
        switch (auth.integerValue) {
            case 0:
            {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                message:@"您还没有开通存管账户哦，请先进行开通！"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self openCGT:controller];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [controller presentViewController:alert animated:YES completion:NULL];
            }
                break;
                
            case 1:
            {
                
                switch (bankcard.integerValue) {
                    case 0:
                    {
                        
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                        message:@"您还没有添加银行卡哦，请先添加银行卡！"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            [self addUserBankcard:controller];
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        [controller presentViewController:alert animated:YES completion:NULL];
                        
                    }
                        break;
                    case 1: {
                        
                        if (success) {
                            success(YES);
                        }
                    }
                        break;
                }
                
            }
                break;
            case 2:
            {
                
                CGSize imageSize = [UIImage imageNamed:@"app_bg_pop_yhcg"].size;
                CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) -30;
                CGFloat height = width * imageSize.height/imageSize.width;
                HCCGActiveView * activeView = [[HCCGActiveView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
                TYAlertController * alertVC = [TYAlertController alertControllerWithAlertView:activeView preferredStyle:TYAlertControllerStyleAlert];
                alertVC.alertViewOriginY =CGRectGetHeight([UIScreen mainScreen].bounds)*0.20;
                __weak typeof(UIViewController *)weakVC = controller;
            
                [controller presentViewController:alertVC animated:YES completion:NULL];
                
                __weak typeof(TYAlertController *)weakAlertVC = alertVC;

                activeView.detailButtonCallBack = ^{
                    [weakAlertVC dismissViewControllerAnimated:YES];
                    NSString * url = [NSString stringWithFormat:@"%@%@",WebBaseURL,@"bank-custody"];

                    UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
                    [weakVC.navigationController pushViewController:controller animated:YES];
                };
                activeView.openButtonCallBack = ^{
                    [weakAlertVC dismissViewControllerAnimated:YES];
                    [HCCheckUserService activeCGT:weakVC];
                };
                
            }
                break;
                
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];

        
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
            
        }
        
    }];
}
+ (void)openCGT:(UIViewController *)controller {
    
    HCUserIdentityView * view = [[HCUserIdentityView alloc] initWithFrame:CGRectZero];
    TYAlertController * alert = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationFade];
    alert.alertViewOriginY = [UIScreen mainScreen].bounds.size.height *0.2;
    
    [controller presentViewController:alert animated:YES completion:NULL];
    __weak typeof(TYAlertController *) weakVC = alert;
    https://cg2.unitedbank.cn/bha-neo-app/lanmaotech/gateway
    view.cancelButtonClickCallBack = ^{
        [weakVC dismissViewControllerAnimated:YES];
    };
    view.confirmButtonClickCallBack = ^(NSDictionary *params) {
        [weakVC dismissViewControllerAnimated:YES];
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"realName"] = params[@"realName"];
        param[@"idCardNo"] = params[@"idCardNo"];
        param[@"token"] = user[@"token"];
        param[@"controller"] = controller;
        [[CTMediator sharedInstance] HCGateWayBusiness_yeePayRegisterWithRequestParams:param];
    };
}

+ (void)activeCGT:(UIViewController *)controller {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = user[@"token"];
    param[@"controller"] = controller;
    [[CTMediator sharedInstance] HCGateWayBusiness_cgtActiveWithRequestParams:param];
}

+ (void)addUserBankcard:(UIViewController * )mycontroller {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"]=  user[@"token"];
    params[@"controller"] = mycontroller;
    [[CTMediator sharedInstance] HCGateWayBusiness_bindBankcardWithRequestParams:params];
}
@end

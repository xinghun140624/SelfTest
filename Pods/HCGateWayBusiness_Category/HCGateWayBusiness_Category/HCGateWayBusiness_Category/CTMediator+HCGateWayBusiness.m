//
//  CTMediator+HCGateWayBusiness.m
//  HCGateWayBusiness_Category
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCGateWayBusiness.h"

@implementation CTMediator (HCGateWayBusiness)
- (void)HCGateWayBusiness_yeePayRegisterWithRequestParams:(NSDictionary *)requestParams;
{
    [self performTarget:@"HCGateWayBusiness" action:@"yeePayRegister" params:requestParams shouldCacheTarget:NO];

}

- (void)HCGateWayBusiness_rechargeWithRequestParams:(NSDictionary *)requestParams
{
    [self performTarget:@"HCGateWayBusiness" action:@"recharge" params:requestParams shouldCacheTarget:NO];
}
- (void)HCGateWayBusiness_paymentWithRequestParams:(NSDictionary *)requestParams
{

    [self performTarget:@"HCGateWayBusiness" action:@"payment" params:requestParams shouldCacheTarget:NO];
}


- (void)HCGateWayBusiness_rechargeAndPaymentWithRequestParams:(NSDictionary *)requestParams
{
    [self performTarget:@"HCGateWayBusiness" action:@"rechargeAndPayment" params:requestParams shouldCacheTarget:NO];
}

- (void)HCGateWayBusiness_withDrawWithRequestParams:(NSDictionary *)requestParams
{

    [self performTarget:@"HCGateWayBusiness" action:@"withDraw" params:requestParams shouldCacheTarget:NO];

}
- (void)HCGateWayBusiness_bindBankcardWithRequestParams:(NSDictionary *)requestParams
{
    [self performTarget:@"HCGateWayBusiness" action:@"bindBankcard" params:requestParams shouldCacheTarget:NO];
}


- (void)HCGateWayBusiness_jieBangBankcardWithRequestParams:(NSDictionary *)requestParams
{

    [self performTarget:@"HCGateWayBusiness" action:@"jieBangBankcard" params:requestParams shouldCacheTarget:NO];

}

- (void)HCGateWayBusiness_bankCardMobileWithRequestParams:(NSDictionary *)requestParams
{
    [self performTarget:@"HCGateWayBusiness" action:@"bankCardMobile" params:requestParams shouldCacheTarget:NO];
}

- (void)HCGateWayBusiness_cgtActiveWithRequestParams:(NSDictionary *)requestParams
{
    [self performTarget:@"HCGateWayBusiness" action:@"cgtActive" params:requestParams shouldCacheTarget:NO];
}

- (void)HCGateWayBusiness_resetPayPasswordWithRequestParams:(NSDictionary *)requestParams
{
    [self performTarget:@"HCGateWayBusiness" action:@"resetPayPassword" params:requestParams shouldCacheTarget:NO];
}

- (void)HCGateWayBusiness_userAuthorizeAutoTransferWithRequestParams:(NSDictionary *)requestParams
{
    [self performTarget:@"HCGateWayBusiness" action:@"userAuthorizeAutoTransfer" params:requestParams shouldCacheTarget:NO];
    
}
    
- (UIViewController *)HCGateWayBusiness_successViewControllerWithParams:(NSDictionary *)params {

    return [self performTarget:@"HCGateWayBusiness" action:@"successViewController" params:params shouldCacheTarget:NO];
}
@end

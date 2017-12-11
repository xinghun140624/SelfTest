//
//  CTMediator+HCGateWayBusiness.h
//  HCGateWayBusiness_Category
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <CTMediator/CTMediator.h>
typedef void(^blockCallBack)(NSDictionary * info);

@interface CTMediator (HCGateWayBusiness)

/**
 开通存管通
 @param requestParams 请求参数 (realName,token,idCardNo,controller)
 
 */
- (void)HCGateWayBusiness_yeePayRegisterWithRequestParams:(NSDictionary *)requestParams;

/**
 充值
 @param requestParams 请求参数 (token,amount,rechargeWay,controller)
 
 */
- (void)HCGateWayBusiness_rechargeWithRequestParams:(NSDictionary *)requestParams;

/**
 支付
 @param requestParams 请求参数 (token,orderNumber,controller)
 
 */
- (void)HCGateWayBusiness_paymentWithRequestParams:(NSDictionary *)requestParams;

/**
 充值并支付
 @param requestParams 请求参数 (token,investAmount,projectNumber,couponNumber：如果有值就传，没有不传)
 */
- (void)HCGateWayBusiness_rechargeAndPaymentWithRequestParams:(NSDictionary *)requestParams;

/**
 提现
 @param requestParams 请求参数 (token,amount,controller)
 
 */
- (void)HCGateWayBusiness_withDrawWithRequestParams:(NSDictionary *)requestParams;

/**
 绑定银行卡
 @param requestParams 请求参数 (token,controller)
 
 */
- (void)HCGateWayBusiness_bindBankcardWithRequestParams:(NSDictionary *)requestParams;
/**
 解绑银行卡
 @param requestParams 请求参数 (token,controller)
 
 */
- (void)HCGateWayBusiness_jieBangBankcardWithRequestParams:(NSDictionary *)requestParams;
/**
 修改预留手机号
 @param requestParams 请求参数 (token,controller)
 
 */
- (void)HCGateWayBusiness_bankCardMobileWithRequestParams:(NSDictionary *)requestParams;
/**
 存管通激活
 @param requestParams 请求参数 (token,controller)
 
 */
- (void)HCGateWayBusiness_cgtActiveWithRequestParams:(NSDictionary *)requestParams;



/**
 修改支付密码
 @param requestParams 请求参数 (token,controller)
 
 */
- (void)HCGateWayBusiness_resetPayPasswordWithRequestParams:(NSDictionary *)requestParams;

/**
 用户授权开启自动投标
 @param requestParams 请求参数 (token,controller)
 
 */
- (void)HCGateWayBusiness_userAuthorizeAutoTransferWithRequestParams:(NSDictionary *)requestParams;

/**
 成功页

 @param params 参数
 @return 成功控制器
 */
- (UIViewController *)HCGateWayBusiness_successViewControllerWithParams:(NSDictionary *)params;
@end

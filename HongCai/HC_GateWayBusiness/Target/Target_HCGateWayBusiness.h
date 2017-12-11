//
//  Target_HCGateWayBusiness.h
//  HC_GateWayBusiness
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Target_HCGateWayBusiness : NSObject

- (void)Action_yeePayRegister:(NSDictionary *)params;
- (void)Action_recharge:(NSDictionary *)params;
- (void)Action_payment:(NSDictionary *)params;
- (void)Action_rechargeAndPayment:(NSDictionary *)params;
- (void)Action_withDraw:(NSDictionary *)params;
- (void)Action_bindBankcard:(NSDictionary *)params;
- (void)Action_jieBangBankcard:(NSDictionary *)params;
- (void)Action_cgtActive:(NSDictionary *)params;
- (void)Action_bankCardMobile:(NSDictionary *)params;
- (void)Action_resetPayPassword:(NSDictionary *)params;
- (void)Action_userAuthorizeAutoTransfer:(NSDictionary *)params;

- (UIViewController *)Action_successViewController:(NSDictionary *)params;

@end

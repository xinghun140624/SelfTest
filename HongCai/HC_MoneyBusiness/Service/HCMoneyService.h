//
//  HCRechargeService.h
//  HongCai
//
//  Created by Candy on 2017/7/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCUserBankCardModel.h"
#import "HCWithDrawModel.h"
@interface HCMoneyService : NSObject
+ (void)getRechargeData:(void(^)(NSDecimalNumber *balance,HCUserBankCardModel * model,NSDictionary *bankLimitData))data errorMessage:(void(^)(NSString *errorMessage))errorMessage;
+ (void)getAvailableCashData:(void(^)(HCWithDrawModel * model,NSDictionary *freeCount))model  errorMessage:(void(^)(NSString *errorMessage))errorMessage;
@end

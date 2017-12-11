//
//  HCSettingService.h
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCUserBankCardModel.h"
#import "HCUserAutoTenderModel.h"
@interface HCSettingService : NSObject
+ (void)getUserBankCardWithToken:(NSString *)token success:(void(^)(HCUserBankCardModel *model))success;
+ (void)getUserQuestionWithToken:(NSString *)token success:(void(^)(NSString *desc))success;


+ (void)getUserAutoTenderWithToken:(NSString *)token success:(void(^)(HCUserAutoTenderModel *model))success;

@end

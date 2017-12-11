//
//  HCMeService.h
//  HongCai
//
//  Created by Candy on 2017/7/6.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCAccountModel.h"

@interface HCMeService : NSObject
/**
 获得用户信息
 */
+ (void)getUserAccountInformationWithToken:(NSString *)token success:(void(^)(HCAccountModel *model))accountModel;
+ (void)getUserCouponStatWithToken:(NSString *)token success:(void(^)(NSInteger unUsedCouponCount))success;
+ (void)getUserUnReadMsgsWithToken:(NSString *)token success:(void(^)(BOOL isHaveUnReadCount))success;
@end

//
//  HCCreditorTransferService.h
//  HongCai
//
//  Created by Candy on 2017/7/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCAssignmentRuleApi.h"
#import "HCAssignmentRuleModel.h"
#import "HCMyInvestModel.h"
#import "HCCreditTransfer_TransferablesApi.h"
#import "HCAssignmentModel.h"


@interface HCCreditorTransferService : NSObject
+ (void)loadAssignmentRuleWithToken:(NSString *)token success:(void(^)(HCAssignmentRuleModel * model))success;
+ (void)loadTransferableDataWithPage:(NSInteger )page success:(void(^)(NSArray *models,BOOL isFinish))success;
+ (void)loadAssignmentTransferDataWithPage:(NSInteger )page types:(NSArray *)types success:(void(^)(NSArray *models,BOOL isFinish))success;
@end

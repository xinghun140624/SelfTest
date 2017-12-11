//
//  HCAssignmentRuleModel.h
//  HongCai
//
//  Created by Candy on 2017/7/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCAssignmentRuleModel : NSObject <YYModel>
@property (nonatomic, strong) NSNumber * borderDay;
@property (nonatomic, strong) NSDecimalNumber * discountFeeRate;
@property (nonatomic, strong) NSNumber * endLimit;
@property (nonatomic, strong) NSNumber * startLimit;
@property (nonatomic, strong) NSDecimalNumber * greaterThanBorderDayFee;
@property (nonatomic, strong) NSDecimalNumber * lessThanOrEqualBorderDayFee;
@property (nonatomic, strong) NSDecimalNumber * maxReceivedPaymentsRate;
@property (nonatomic, strong) NSDecimalNumber * minAnnualEarnings;
@property (nonatomic, strong) NSDecimalNumber * minFee;
@property (nonatomic, assign) BOOL recycleReward;
@end

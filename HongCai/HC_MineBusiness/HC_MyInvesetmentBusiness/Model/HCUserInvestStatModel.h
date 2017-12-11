//
//  HCUserInvestStatModel.h
//  HongCai
//
//  Created by Candy on 2017/7/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCUserInvestStatModel : NSObject<YYModel>
@property (nonatomic, strong) NSDecimalNumber *profit;
@property (nonatomic, strong) NSDecimalNumber *totalProfit;
@property (nonatomic, strong) NSDecimalNumber *totalInvestAmountNoAssignment;
@property (nonatomic, strong) NSDecimalNumber *totalInvestAmount;
@property (nonatomic, strong) NSDecimalNumber *holdingAmount;
@property (nonatomic, assign) NSInteger totalInvestCount;
@property (nonatomic, assign) NSInteger endProfitCount;
@property (nonatomic, assign) NSInteger holdingCount;
@property (nonatomic, assign) NSInteger creditRightType;
@end

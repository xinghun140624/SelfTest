//
//  HCAccountModel.h
//  HongCai
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCAccountModel : NSObject<YYModel>
@property (nonatomic, strong) NSDecimalNumber* activityProfit;
@property (nonatomic, strong) NSDecimalNumber* availableCash;
@property (nonatomic, strong) NSDecimalNumber* balance;
@property (nonatomic, strong) NSNumber* createTime;
@property (nonatomic, strong) NSString * custodyAccount;
@property (nonatomic, strong) NSDecimalNumber* freezeCapital;
@property (nonatomic, strong) NSDecimalNumber* hongbaoTotalProfit;
@property (nonatomic, strong) NSNumber* accountId;
@property (nonatomic, strong) NSDecimalNumber* investAmount;
@property (nonatomic, copy  ) NSString * name;
@property (nonatomic, strong) NSDecimalNumber* receivedCapital;
@property (nonatomic, strong) NSDecimalNumber* receivedProfit;
@property (nonatomic, strong) NSDecimalNumber* reward;
@property (nonatomic, strong) NSDecimalNumber* totalAssets;
@property (nonatomic, strong) NSDecimalNumber* totalProfit;
@property (nonatomic, strong) NSNumber* updateTime;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSDecimalNumber* waitingCapital;
@property (nonatomic, strong) NSDecimalNumber* waitingProfit;
@end

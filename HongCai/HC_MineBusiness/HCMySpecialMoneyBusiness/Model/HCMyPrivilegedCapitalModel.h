//
//  HCMyPrivilegedCapitalModel.h
//  HongCai
//
//  Created by Candy on 2017/7/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCMyPrivilegedCapitalModel : NSObject<YYModel>
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *investUserId;
@property (nonatomic, strong) NSNumber *activityId;
@property (nonatomic, strong) NSDecimalNumber *profit;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSDecimalNumber *investAmount;
@property (nonatomic, strong) NSDecimalNumber *settleInvestAmount;
@property (nonatomic,   copy) NSString *desc;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *dueTime;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic,   copy) NSString *mobile;
@property (nonatomic, strong) NSNumber *registTime;
@property (nonatomic, strong) NSNumber *firstInvestTime;

@end

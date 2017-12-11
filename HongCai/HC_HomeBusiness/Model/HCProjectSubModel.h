//
//  HCProjectSubModel.h
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCProjectSubModel : NSObject<YYModel>
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *number;
@property (nonatomic, strong) NSDecimalNumber *annualEarnings;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSNumber *projectDays;
@property (nonatomic, strong) NSNumber *repaymentType;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic,   copy) NSString *image;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *increaseAmount;
@property (nonatomic, strong) NSNumber *releaseStartTime;
@property (nonatomic, strong) NSNumber *releaseEndTime;
@property (nonatomic,   copy) NSString *guaranteeName;
@property (nonatomic, strong) NSString *typeName;

@end

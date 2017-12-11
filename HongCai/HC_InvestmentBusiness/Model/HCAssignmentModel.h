//
//  HCAssignmentSubModel.h
//  HongCai
//
//  Created by Candy on 2017/6/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCAssignmentModel : NSObject<YYModel>
@property (nonatomic, strong) NSNumber *assignmentId;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSString *projectNumber;
@property (nonatomic, strong) NSNumber *creditRightId;
@property (nonatomic,   copy) NSString *orderNum;
@property (nonatomic,   copy) NSString *number;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *annualEarnings;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSDecimalNumber *discountAmount;
@property (nonatomic, strong) NSDecimalNumber *originalAnnualEarnings;
@property (nonatomic, strong) NSDecimalNumber *transferedIncome;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *remainDay;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *occupancyStock;
@property (nonatomic, strong) NSNumber *soldStock;
@property (nonatomic, strong) NSNumber *currentStock;
@property (nonatomic, strong) NSNumber *subscribeNumber;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, strong) NSNumber *updateTime;
@property (nonatomic,   copy) NSString *image;
@end

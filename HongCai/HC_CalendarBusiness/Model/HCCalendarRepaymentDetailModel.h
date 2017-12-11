//
//  HCCalendarRepaymentDetailModel.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
//projectName:项目名称，
//investAmount：投资金额，
//baseRate: 项目利率，
//couponRate: 加息券利率，
//principalAmount:回款本金，
//interestAmount: 回款利息，
//valueDate: 计息时间，
//repaymentDate: 本息两清日期
@interface HCCalendarDetailVoModel : NSObject<YYModel>
@property (nonatomic, copy) NSString * projectName;
@property (nonatomic,   copy) NSString *creditRightNum;
@property (nonatomic, strong) NSDecimalNumber *investAmount;
@property (nonatomic, assign) float baseRate;
@property (nonatomic, assign) float couponRate;
@property (nonatomic, strong) NSDecimalNumber *principalAmount;
@property (nonatomic, strong) NSDecimalNumber *interestAmount;
@property (nonatomic, assign) NSTimeInterval valueDate;
@property (nonatomic, assign) NSTimeInterval repaymentDate;
@property (nonatomic, assign) int billType;
@property (nonatomic, assign) NSInteger raiseDays;
@property (nonatomic, assign) NSInteger valueDays;

@end




@interface HCCalendarRepaymentDetailModel : NSObject<YYModel>
@property (nonatomic, strong) NSDecimalNumber *anticipateAmount;
@property (nonatomic, strong) NSDecimalNumber *waitingAmount;
@property (nonatomic, strong) NSDecimalNumber *receivedAmount;
@property (nonatomic, strong) NSDecimalNumber *principalAmount;
@property (nonatomic, strong) NSDecimalNumber *interestAmount;
@property (nonatomic, strong) NSArray <HCCalendarDetailVoModel *>*details;
@end

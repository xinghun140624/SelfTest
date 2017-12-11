//
//  HCUserCreditRightModel.h
//  HongCai
//
//  Created by Candy on 2017/7/18.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "HCMyCouponModel.h"


@interface HCCreditAssignmentFeeModel : NSObject
@property (nonatomic,   copy) NSString *creditRightNumber;
@property (nonatomic, assign) NSInteger originalCreditRightId;
@property (nonatomic, strong) NSDecimalNumber *receiveProfit;
@property (nonatomic, strong) NSDecimalNumber *spreadProfit;
@property (nonatomic, strong) NSDecimalNumber *serviceFee;
@property (nonatomic, strong) NSDecimalNumber *recycleReward;

@end

@interface HCUserCreditRightModel : NSObject
@property (nonatomic, strong) NSNumber * projectId;
@property (nonatomic, copy) NSString * projectName;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, strong) NSNumber * creditRightAssignmentId;
@property (nonatomic, strong) NSDecimalNumber * amount;
@property (nonatomic, strong) NSDecimalNumber * payAmount;
@property (nonatomic, strong) NSDecimalNumber * profit;
@property (nonatomic, strong) NSDecimalNumber * returnProfit;
@property (nonatomic, strong) NSDecimalNumber * discountInterest;
@property (nonatomic, strong) NSDecimalNumber * transferableAmount;
@property (nonatomic, strong) NSDecimalNumber * transferingAmount;
@property (nonatomic, strong) NSDecimalNumber * transferedAmount;
@property (nonatomic, strong) NSDecimalNumber * baseRate;
@property (nonatomic, strong) NSDecimalNumber * riseRate;
@property (nonatomic, assign) NSInteger repeatInvestMaxCount;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * createTime;
@property (nonatomic, strong) NSNumber * updateTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger transferStatus;
@property (nonatomic, assign) NSInteger repeatInvestStatus;
@property (nonatomic, assign) NSInteger isRepeatInvest;
@property (nonatomic, assign) NSInteger fundsPoolInOut;
@property (nonatomic, copy) NSString * fundsPoolCode;
@property (nonatomic, assign) NSInteger device;
@property (nonatomic, assign) NSInteger valueDate;
@property (nonatomic, assign) NSInteger repaymentDate;
@property (nonatomic, strong) NSDecimalNumber * commission;

@end


@interface HCUserCreditProjectModel : NSObject
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger repaymentType;
@property (nonatomic, strong) NSDecimalNumber * minInvest;
@property (nonatomic, strong) NSDecimalNumber * maxInvest;
@property (nonatomic, strong) NSDecimalNumber * increaseAmount;
@property (nonatomic, assign) NSInteger countInvest;
@property (nonatomic, strong) NSDecimalNumber * total;
@property (nonatomic, assign) NSInteger cycle;
@property (nonatomic, assign) NSInteger currentStock;
@property (nonatomic, assign) NSInteger soldStock;
@property (nonatomic, assign) NSInteger occupancyStock;
@property (nonatomic, strong) NSDecimalNumber * annualEarnings;
@property (nonatomic, strong) NSDecimalNumber * floattingRate;
@property (nonatomic, assign) NSInteger repaymentDate;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger hongbaoStatus;
@property (nonatomic, assign) NSInteger guaranteeId;
@property (nonatomic, assign) NSInteger enterpriseId;
@property (nonatomic, assign) NSInteger releaseStartTime;
@property (nonatomic, assign) NSInteger releaseEndTime;
@property (nonatomic, assign) NSInteger adminId;
@property (nonatomic, copy) NSString * adminName;
@property (nonatomic, copy) NSString * guaranteeName;
@property (nonatomic, copy) NSString * enterpriseName;
@property (nonatomic, assign) NSInteger isRecommend;
@property (nonatomic, assign) NSInteger publishTime;
@property (nonatomic, assign) NSInteger valueDate;
@property (nonatomic, assign) NSInteger accountDay;
@property (nonatomic, assign) NSInteger projectDays;
@property (nonatomic, assign) NSInteger loanTime;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger projectRankid;
@property (nonatomic, assign) NSInteger guaranteeType;
@property (nonatomic, assign) NSInteger currentInterestStatus;
@property (nonatomic, assign) NSInteger reserveInterestStatus;
@property (nonatomic, assign) NSInteger reserveStartTime;
@property (nonatomic, assign) NSInteger reserveEndTime;
@property (nonatomic, strong) NSDecimalNumber * realReserveAmount;
@property (nonatomic, strong) NSDecimalNumber * needCompletionReserverAmount;
@property (nonatomic, strong) NSDecimalNumber * reserveAmount;
@property (nonatomic, assign) NSInteger accountUserId;
@property (nonatomic, copy) NSString * accountUserName;
@property (nonatomic, assign) NSInteger investNum;
@property (nonatomic, assign) NSInteger investorNum;
@property (nonatomic, assign) NSInteger loanEnterpriseId;
@property (nonatomic, copy) NSString * loanEnterpriseName;
@property (nonatomic, assign) NSInteger releaseDays;

@end


@interface HCProjectBillModel  : NSObject;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger lastRepaymentTime;
@property (nonatomic, assign) NSInteger reserveInterestStatus;
@property (nonatomic, strong) NSDecimalNumber * remainInterest;
@property (nonatomic, strong) NSDecimalNumber * remainPrincipal;
@property (nonatomic, assign) NSInteger repaymentSource;
@end




@interface HCUserCreditRightDetailModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger creditRightId;
@property (nonatomic, strong) HCUserCreditRightModel * creditRightModel;
@property (nonatomic, strong) HCUserCreditProjectModel * projectModel;
@property (nonatomic, strong) HCProjectBillModel * projectBillModel;
@property (nonatomic, strong) HCCreditAssignmentFeeModel * feeModel;


@property (nonatomic, strong) HCMyCouponModel * couponModel;
@end



/*
{
    "creditRightId": 40755,
    "creditRight": {
        "id": 40755,
        "projectId": 417,
        "projectName": "电力设备销售公司融资项目",
        "number": "8494170510421210399082",
        "creditRightAssignmentId": 0,
        "orderNum": "527992017051012102655621",
        "amount": 5000.00,
        "payAmount": 5000.00,
        "profit": 241.65,
        "returnProfit": 81.89,
        "discountInterest": 0.00,
        "transferableAmount": 5000.00,
        "transferingAmount": 0.00,
        "transferedAmount": 0.00,
        "baseRate": 9.80,
        "riseRate": 0.00,
        "repeatInvestMaxCount": 0,
        "userId": 117361,
        "createTime": 1494389439977,
        "updateTime": 1496972578000,
        "status": 2,
        "type": 8,
        "transferStatus": 1,
        "repeatInvestStatus": null,
        "repeatInvestCount": null,
        "isRepeatInvest": null,
        "fundsPoolInOut": 1,
        "fundsPoolCode": null,
        "device": 0,
        "valueDate": 0,
        "repaymentDate": 0,
        "commission": 0,
        "coupon": null,
        "normalType": true
    },
    "project": {
        "id": 417,
        "number": "620825608170507100",
        "name": "电力设备销售公司融资项目",
        "image": "jpg/thumbnail/2017-05-07/project/project-db31e89e382c46bcb23eaab5a9c896b8-thumbnail.jpg",
        "categoryId": 8,
        "repaymentType": 1,
        "minInvest": 100,
        "maxInvest": null,
        "increaseAmount": 100.000,
        "countInvest": 3306,
        "total": 330600,
        "cycle": 6,
        "currentStock": 0,
        "soldStock": 3306,
        "occupancyStock": 0,
        "annualEarnings": 9.800,
        "floattingRate": null,
        "repaymentDate": 1509991212811,
        "status": 9,
        "hongbaoStatus": 0,
        "guaranteeId": -1,
        "enterpriseId": 83,
        "releaseStartTime": 1494382413743,
        "releaseEndTime": 1495592013743,
        "adminId": 112,
        "adminName": "成沛",
        "guaranteeName": "",
        "enterpriseName": "重庆环琪电力机电设备有限公司",
        "isRecommend": 0,
        "publishTime": 1494382413742,
        "valueDate": 1494439212811,
        "accountDay": 11,
        "projectDays": 180,
        "loanTime": 1494439212811,
        "type": 8,
        "createTime": 0,
        "updateTime": null,
        "projectRankid": 3,
        "guaranteeType": 2,
        "currentInterestStatus": -1,
        "reserveInterestStatus": 0,
        "reserveStartTime": 1494067064874,
        "reserveEndTime": 1494153464874,
        "reserveAmount": 0,
        "accountUserId": 0,
        "accountUserName": null,
        "projectInfo": null,
        "guarantee": null,
        "projectRank": null,
        "category": null,
        "investNum": 0,
        "investorNum": 0,
        "loanEnterpriseId": 0,
        "loanEnterpriseName": null,
        "releaseDays": 0,
        "creditRightType": 1,
        "cgtStockProject": false,
        "not_LOAN_START_TIME": 1500382800000,
        "not_LOAN_END_TIME": 1500393600000
    },
    "projectBill": {
        "id": 2296,
        "projectId": 0,
        "requestNo": "620825608170507100_3_0_0",
        "repaymentTime": 1502388012811,
        "realRepaymentTime": 0,
        "category": 0,
        "repaymentPrincipal": 0.000,
        "repaymentInterest": 2751.690,
        "repaymentAmount": 2751.690,
        "repaymentSource": 0,
        "status": 0,
        "couponProfitRequestNo": null,
        "experienceProfitRequestNo": null,
        "createTime": 0,
        "updateTime": null,
        "repaymentNo": 3,
        "lastRepaymentTime": 1499709612811,
        "remainInterest": 7811.220,
        "remainPrincipal": 330600.000,
        "type": 1,
        "repaymentCouponProfit": false,
        "repaymentExperienceProfit": false
    },
    "increaseRateCoupon": null
}

*/

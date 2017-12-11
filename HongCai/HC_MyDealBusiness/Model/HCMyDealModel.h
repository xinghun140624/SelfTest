//
//  HCMyDealModel.h
//  HC_MyDealBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCMyDealModel : NSString<YYModel>

@property (nonatomic, strong) NSDecimalNumber * amount;
@property (nonatomic, strong) NSDecimalNumber * balance;
@property (nonatomic, strong) NSNumber * createTime;
@property (nonatomic,   copy) NSString * desc;
@property (nonatomic,   copy) NSString * getAccount;
@property (nonatomic,   copy) NSString * getAccountName;
@property (nonatomic, strong) NSDecimalNumber * getAmount;
@property (nonatomic, strong) NSDecimalNumber * getProfit;
@property (nonatomic,   copy) NSString * getName;
@property (nonatomic, strong) NSNumber * getTime;
@property (nonatomic, strong) NSNumber * dealId;
@property (nonatomic,   copy) NSString * number;
@property (nonatomic, strong) NSDecimalNumber * payAmount;
@property (nonatomic, strong) NSNumber * payFavorable;
@property (nonatomic,   copy) NSString * payName;
@property (nonatomic, strong) NSNumber * payTime;
@property (nonatomic, strong) NSNumber * payTotal;
@property (nonatomic, strong) NSNumber * payType;
@property (nonatomic,   copy) NSString * projectNo;
@property (nonatomic, strong) NSNumber * source;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSNumber * successTime;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * updateTime;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic,   copy) NSString * dealTypeDesc;

@end

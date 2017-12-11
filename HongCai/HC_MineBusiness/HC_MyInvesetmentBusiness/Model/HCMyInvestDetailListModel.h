//
//  HCMyInvestDetailListModel.h
//  HongCai
//
//  Created by Candy on 2017/7/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCMyInvestDetailListModel : NSObject <YYModel>
@property (nonatomic, strong) NSDecimalNumber * amount;
@property (nonatomic, strong) NSDecimalNumber * couponProfit;
@property (nonatomic, strong) NSDecimalNumber * profit;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy)  NSString * date;
//{"amount":0,"couponProfit":0,"type":3,"status":1,"date":"1970-01-01"}
@end

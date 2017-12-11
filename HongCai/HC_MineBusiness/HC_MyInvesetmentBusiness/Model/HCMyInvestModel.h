//
//  HCMyInvestModel.h
//  Pods
//
//  Created by Candy on 2017/7/10.
//
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCMyInvestModel : NSObject<YYModel>
@property (nonatomic,   copy) NSString *number;
@property (nonatomic,   copy) NSString *projectName;
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSDecimalNumber *profit;
@property (nonatomic, strong) NSDecimalNumber *returnProfit;

@property (nonatomic, strong) NSDecimalNumber *couponProfit;
@property (nonatomic, strong) NSNumber *repaymentDate;
@property (nonatomic, strong) NSDecimalNumber *couponValue;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSNumber * createTime;
@end

//
//  HCGoToTransferConfirmView.h
//  Pods
//
//  Created by Candy on 2017/7/7.
//
//

#import <UIKit/UIKit.h>
#import "HCGoToInvestConfirmHeaderView.h"

@interface HCGoToTransferConfirmView : UIView
@property (nonatomic, copy) void(^backButtonCallBack)(void);
@property (nonatomic, strong) NSNumber *userBalance;
@property (nonatomic, strong, readonly) HCGoToInvestConfirmHeaderView *headerView;
@property (nonatomic, strong) NSString *payMoney;//实际支付
@property (nonatomic, strong) NSNumber *shouyiAmount;
@property (nonatomic, strong) NSNumber * investAmount;//投资金额
@property (nonatomic, strong) NSNumber * originalAnnualEarnings;
@property (nonatomic, strong) NSNumber * annualEarnings;
@property (nonatomic, strong) NSNumber *projectDays;

@property (nonatomic, copy) void(^confirmButtonCallBack)(void);
@end

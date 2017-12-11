//
//  HCInvestmentConfirmView.h
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCGoToInvestConfirmHeaderView.h"
#import "HCGoToInvestCouponModel.h"



@protocol HCGoToInvestConfirmViewDelegate <NSObject>
- (void)gotoInvestConfirmViewInvestButtonClick:(UIButton *)button;

@end



@interface HCGoToInvestConfirmView : UIView
@property (nonatomic, copy) NSString * projectNumber;
@property (nonatomic, strong, readonly) HCGoToInvestConfirmHeaderView *headerView;
@property (nonatomic, weak) id <HCGoToInvestConfirmViewDelegate>delegate;

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSNumber *investmentAmount;
@property (nonatomic, strong) NSNumber *userBalance;
//年度收益
@property (nonatomic, strong) NSDecimalNumber *annualEarnings;
//项目天数
@property (nonatomic, strong) NSNumber *projectDays;

@property (nonatomic, strong) NSArray * couponArray;
@property (nonatomic, assign) BOOL isPartake;//是否支持降息换物
@property (nonatomic, copy) NSString * specailInvestDesc;
@property (nonatomic, copy) void(^backButtonCallBack)(void);
@property (nonatomic, copy) void(^couponsCellSelectCallBack)(UITableViewCell *cell);
@property (nonatomic, strong, readonly) UIButton *confirmButton;



@end

//
//  HCImmediatelyInputCell.h
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCUserCreditRightDetailModel;
@class HCAssignmentRuleModel;
@interface HCImmediatelyInputCell : UITableViewCell
//转让金额
@property (nonatomic, strong, readonly) UITextField *amountInputTextField;

//转让利率
@property (nonatomic, strong, readonly) UITextField *rateInputTextField;


@property (nonatomic, strong) NSDecimalNumber * remainAmount;
@property (nonatomic, strong) NSDecimalNumber * minRate;
@property (nonatomic, strong) HCUserCreditRightDetailModel * detailModel;
@property (nonatomic, strong) HCAssignmentRuleModel * ruleModel;

@property (nonatomic, copy) void (^caculateResultCallBack)(double result, BOOL success);

@end

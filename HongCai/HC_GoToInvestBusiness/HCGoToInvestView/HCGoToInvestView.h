//
//  HCPurchasingView.h
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HCGoToInvestView : UIView
@property (nonatomic, copy) void (^gotoInvestButtonClickCallBack)(int level,NSInteger type,UIButton * confirmButton);
/*项目ID*/
@property (nonatomic, strong) NSNumber *projectId;
/*年化收益*/
@property (nonatomic, strong) NSDecimalNumber *annualEarnings;
/*项目天数*/
@property (nonatomic, strong) NSNumber *projectDays;
/*剩余可投金额*/
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, assign) BOOL isPartake;//是否支持降息换物
@property (nonatomic, strong) NSDecimalNumber *minInvestAmount;
@property (nonatomic, assign) int level;
@property (nonatomic, copy) NSString * specialInvestDesc;
@property (nonatomic, strong, readonly) NSNumber *investAmount;
@property (nonatomic, copy, readonly) NSString *couponNumber;
@property (nonatomic, copy) NSString *projectNumber;

@end

//
//  HCGoToInvestCouponsView.h
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCGoToInvestCouponModel.h"

@interface HCGoToInvestCouponView : UIView
@property (nonatomic, copy) void(^backButtonCallBack)(HCGoToInvestCouponModel * model);
@property (nonatomic, strong) NSArray *couponArray;
@property (nonatomic, strong) NSNumber *investAmount;

@end

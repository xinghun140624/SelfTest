//
//  HCGoToInvestCouponCell.h
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCGoToInvestCouponModel;
@interface HCGoToInvestCouponCell : UITableViewCell
@property (nonatomic, strong) HCGoToInvestCouponModel *model;
@property (nonatomic, strong) NSNumber *investAmount;

@end

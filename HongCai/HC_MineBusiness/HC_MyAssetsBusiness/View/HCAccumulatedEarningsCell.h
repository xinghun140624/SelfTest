//
//  HCAccumulatedEarningsCell.h
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
// 累计收益（活动收益or投资收益）

#import <UIKit/UIKit.h>
@class HCMyDealModel;

@interface HCAccumulatedEarningsCell : UITableViewCell
@property (nonatomic, strong) HCMyDealModel * model;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *moneyLabel;
@end

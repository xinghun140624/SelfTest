//
//  HCMyAssetsEarningsCell.h
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCAccountModel.h"
@interface HCMyAssetsEarningsCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *descLabel;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *iconView;
@property (nonatomic, strong) HCAccountModel * model;

@end

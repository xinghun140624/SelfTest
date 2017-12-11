//
//  HCInvestmentCell.h
//  HongCai
//
//  Created by Candy on 2017/6/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCProjectSubModel;
@class HCAssignmentModel;
@interface HCInvestmentCell : UITableViewCell
@property (nonatomic, strong, readwrite) HCProjectSubModel * project;
@property (nonatomic, strong, readwrite) HCAssignmentModel * assignment;

@property (nonatomic, strong, readonly) UILabel *statusLabel;

@end

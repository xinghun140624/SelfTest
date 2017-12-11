//
//  HCSpecialInvestCell.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSpecialInvestModel.h"
@interface HCSpecialInvestSpaceCell : UITableViewCell
- (void)setupHeight:(CGFloat)height;
@end


@interface HCSpecialInvestCell : UITableViewCell
@property (nonatomic, strong) HCSpecialInvestRuleModel * ruleModel;
@end

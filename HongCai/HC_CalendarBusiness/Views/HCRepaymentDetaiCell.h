//
//  HCRepaymentDetaiCell.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCCalendarDetailVoModel;
@interface HCRepaymentDetaiCell : UITableViewCell
@property (nonatomic, assign) int type;
@property (nonatomic, strong) HCCalendarDetailVoModel * model;
@end

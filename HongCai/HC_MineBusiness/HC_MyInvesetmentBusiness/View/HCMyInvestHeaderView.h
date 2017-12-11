//
//  HCMyInvestHeaderView.h
//  HongCai
//
//  Created by 郭金山 on 2017/9/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCChart.h"
@interface HCMyInvestHeaderView : UIView
@property (nonatomic, strong, readonly) UILabel * statusLabel;
@property (nonatomic, strong, readonly) SCPieChart * chartView;

@end

//
//  HCSpecialInvestController.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
///特权投资
@interface HCSpecialInvestController : UIViewController
@property (nonatomic, copy) void(^selectLevel)(int level,NSDecimalNumber * baseRate,NSDecimalNumber *minInvestAmount,NSString * desc);
@property (nonatomic, assign) int projectType;
@end

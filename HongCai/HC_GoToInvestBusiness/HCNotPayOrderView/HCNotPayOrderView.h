//
//  HCNotPayOrderView.h
//  HC_GoToInvestBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCNotPayOrderView : UIView
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy) void (^countinueButtonClickCallBack)(void);
@end

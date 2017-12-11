//
//  HCPurchasingFirstView.h
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCGoToInvestHomeView;

@protocol HCGoToInvestHomeViewDelegate <NSObject>
- (void)goToInvestHomeView:(HCGoToInvestHomeView *)view nextButtonClick:(UIButton *)button;

@end

@interface HCGoToInvestHomeView : UIView
@property (nonatomic, strong, readonly) UITextField *moneyTextField;
@property (nonatomic, weak) id <HCGoToInvestHomeViewDelegate>delegate;
@property (nonatomic, strong) NSNumber *userBalance;
@property (nonatomic, strong) NSNumber *remainNumber;
@property (nonatomic, strong,readonly) UIButton *nextButton;

@end

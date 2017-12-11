//
//  HCResetPasswordView.h
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCResetPasswordView;
@protocol HCResetPasswordViewDelegate <NSObject>

- (void)resetPasswordView:(HCResetPasswordView *)resetPasswordView completeButtonClick:(UIButton *)button;

@end

@interface HCResetPasswordView : UIView
@property (nonatomic, weak) id <HCResetPasswordViewDelegate>delegate;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;
@end

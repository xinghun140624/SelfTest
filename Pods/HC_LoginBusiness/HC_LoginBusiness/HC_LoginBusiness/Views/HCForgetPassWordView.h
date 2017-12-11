//
//  HCForgetPassWordView.h
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCForgetPassWordView;
@protocol HCForgetPassWordViewDelegate <NSObject>

- (void)forgetPasswordView:(HCForgetPassWordView *)view nextButtonClick:(UIButton *)button;


@end

@interface HCForgetPassWordView : UIView
@property (nonatomic, weak) id <HCForgetPassWordViewDelegate>delegate;
@property (nonatomic, strong, readonly) UITextField *mobileTextField;
@property (nonatomic, strong, readonly) UITextField *imageCodeTextField;
@property (nonatomic, strong, readonly) UITextField *messageCodeTextField;
@end

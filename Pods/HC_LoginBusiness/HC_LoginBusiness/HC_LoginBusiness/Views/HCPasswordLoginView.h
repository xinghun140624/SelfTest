//
//  HCPasswordLoginView.h
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HCPasswordLoginView;
@protocol HCPasswordLoginViewDelegate <NSObject>

- (void)passwordLoginView:(HCPasswordLoginView *)loginView loginButtonClick:(UIButton *)button;
- (void)passwordLoginView:(HCPasswordLoginView *)loginView registerButtonClick:(UIButton *)button;
- (void)passwordLoginView:(HCPasswordLoginView *)loginView forgetPwdButtonClick:(UIButton *)button;

@end
@interface HCPasswordLoginView : UIView
@property (nonatomic, strong, readonly) UITextField *pwdTextField;
@property (nonatomic, weak) id <HCPasswordLoginViewDelegate>delegate;
@end

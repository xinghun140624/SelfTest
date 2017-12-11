//
//  HCModifyLoginPasswordView.h
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HCModifyLoginPasswordView;
@protocol HCModifyLoginPasswordViewDelegate <NSObject>

- (void)modifyLoginPasswordView:(HCModifyLoginPasswordView *)view completeButtonClick:(UIButton *)button;

@end



@interface HCModifyLoginPasswordView : UIView
@property (nonatomic, weak) id <HCModifyLoginPasswordViewDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField *originalPasswordTextField;
@property (nonatomic, strong, readonly) UITextField *passwordTextField;
@end

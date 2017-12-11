//
//  HCRegisterView.h
//  HongCai
//
//  Created by Candy on 2017/6/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCRegisterView;

@protocol HCRegisterViewDelegate <NSObject>

- (void)registerView:(HCRegisterView *)registerView registerButtonClick:(UIButton *)button;
- (void)registerView:(HCRegisterView *)registerView protocolButtonClick:(id )view;
- (void)registerView:(HCRegisterView *)registerView goLoginButtonClick:(id)view;
@end

@interface HCRegisterView : UIView
@property (nonatomic, weak) id <HCRegisterViewDelegate>delegate;
@property (nonatomic, strong ,readonly) UITextField *mobileTextField;
@property (nonatomic, strong ,readonly) UITextField *imageCodeTextField;
@property (nonatomic, strong ,readonly) UITextField *messageCodeTextField;
@property (nonatomic, strong ,readonly) UITextField *passwordTextField;
@end

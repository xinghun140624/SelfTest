//
//  HCModifyBindingMobileView.h
//  HongCai
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HCModifyBindingMobileView;
@protocol HCModifyBindingMobileViewDelegate <NSObject>

- (void)modifyBindingMobileView:(HCModifyBindingMobileView *)view nextButtonClick:(UIButton *)button;


@end

@interface HCModifyBindingMobileView : UIView
@property (nonatomic, weak) id <HCModifyBindingMobileViewDelegate>delegate;
@property (nonatomic, strong, readonly) UITextField *mobileTextField;
@property (nonatomic, strong, readonly) UITextField *imageCodeTextField;
@property (nonatomic, strong, readonly) UITextField *messageCodeTextField;
@end


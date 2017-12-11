//
//  HCBindingNewMobileView.h
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCBindingNewMobileView;
@protocol HCBindingNewMobileViewDelegate <NSObject>

- (void)bindingNewMobileView:(HCBindingNewMobileView *)view bindingButtonClick:(UIButton *)button;


@end

@interface HCBindingNewMobileView : UIView
@property (nonatomic, weak) id <HCBindingNewMobileViewDelegate>delegate;
@property (nonatomic, strong, readonly) UITextField *mobileTextField;
@property (nonatomic, strong, readonly) UITextField *imageCodeTextField;
@property (nonatomic, strong, readonly) UITextField *messageCodeTextField;
@end

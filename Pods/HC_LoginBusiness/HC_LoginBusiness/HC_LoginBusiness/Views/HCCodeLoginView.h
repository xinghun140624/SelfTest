//
//  HCCodeLoginView.h
//  HongCai
//
//  Created by Candy on 2017/6/7.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCCodeLoginView;
@protocol HCCodeLoginViewDelegate <NSObject>

- (void)codeLoginView:(HCCodeLoginView *)loginView loginButtonClick:(UIButton *)button;
- (void)codeLoginView:(HCCodeLoginView *)loginView registerButtonClick:(UIButton *)button;

@end

@interface HCCodeLoginView : UIView
@property (nonatomic, weak) id <HCCodeLoginViewDelegate>delegate;
@property (nonatomic, strong) NSNumber *mobileNumber;
@property (nonatomic, strong, readonly) UITextField *messageCodeTextField;

@end

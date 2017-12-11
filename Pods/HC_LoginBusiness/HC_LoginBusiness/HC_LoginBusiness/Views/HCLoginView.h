//
//  HCLoginView.h
//  HongCai
//
//  Created by Candy on 2017/6/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCLoginView;
@protocol HCLoginViewDelegate <NSObject>
- (void)loginView:(HCLoginView *)loginView nextButtonClick:(UIButton *)button;
- (void)loginView:(HCLoginView *)loginView registerButtonClick:(UIButton *)button;

@end

@interface HCLoginView : UIView
@property (nonatomic, weak) id <HCLoginViewDelegate>delegate;
@property (nonatomic, strong, readonly) UITextField * mobileTextField;
@end

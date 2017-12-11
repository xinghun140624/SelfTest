//
//  HCLoginBottomLabel.m
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCLoginBottomView.h"
#import "NSBundle+HCLoginModule.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
@interface HCLoginBottomView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation HCLoginBottomView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        NSArray * buttonArray = @[self.leftButton,self.rightButton];
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:CGRectGetWidth([UIScreen mainScreen].bounds)/2.0 leadSpacing:0 tailSpacing:0];
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            if (CGRectGetWidth([UIScreen mainScreen].bounds)==320) {
                make.bottom.mas_equalTo(-30.f);
            }else{
                make.bottom.mas_equalTo(-49.f);
            }
        }];
    }
    return self;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"国企战略投资A轮1亿元" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
        _leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _leftButton.userInteractionEnabled = NO;
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"0x444444"] forState:UIControlStateNormal];
        [_leftButton setImage:[NSBundle login_ImageWithName:@"Registration_icon_gzzl_nor"] forState:UIControlStateNormal];
        _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0,1,0, -1);
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0,-1,0,1);
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"海口联合农商银行正式存管" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
        _rightButton.userInteractionEnabled = NO;
        _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"0x444444"] forState:UIControlStateNormal];
        [_rightButton setImage:[NSBundle login_ImageWithName:@"Registration_icon_yhcg_nor"] forState:UIControlStateNormal];
        _rightButton.titleEdgeInsets = UIEdgeInsetsMake(0,1,0, -1);
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0,-1,0,1);
    }
    return _rightButton;
}
@end

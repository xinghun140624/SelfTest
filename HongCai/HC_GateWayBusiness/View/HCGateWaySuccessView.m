//
//  HCInvestmentSuccessView.m
//  HongCai
//
//  Created by Candy on 2017/6/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGateWaySuccessView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "NSBundle+HCGateWayModule.h"

@interface HCGateWaySuccessView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation HCGateWaySuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconView];
        [self addSubview:self.descLabel];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[NSBundle gateWay_ImageWithName:@"hcbb"]];
    }
    return _iconView;
}
- (UILabel*)descLabel {
    if (!_descLabel){
        _descLabel = [[UILabel alloc] init];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:15.f];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftButton.backgroundColor =[UIColor colorWithHexString:@"0xfc622d"];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _leftButton.tintColor = [UIColor whiteColor];
        
        CGFloat buttonWidth =  CGRectGetWidth([UIScreen mainScreen].bounds)*(316.0/750.0);
        CGFloat buttonHeight = buttonWidth*(85.0/316.0);
        _leftButton.layer.cornerRadius = buttonHeight*0.5;
        _leftButton.layer.shadowColor =_leftButton.backgroundColor.CGColor;
        _leftButton.layer.shadowOpacity = 0.3;
                _leftButton.layer.shadowOffset = CGSizeMake(0, 4);

    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.backgroundColor =[UIColor colorWithHexString:@"0xffc600"];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _rightButton.tintColor = [UIColor whiteColor];
        
        CGFloat buttonWidth =  CGRectGetWidth([UIScreen mainScreen].bounds)*(316.0/750.0);
        CGFloat buttonHeight = buttonWidth*(85.0/316.0);
        _rightButton.layer.cornerRadius = buttonHeight*0.5;
        _rightButton.layer.shadowColor =_rightButton.backgroundColor.CGColor;
        _rightButton.layer.shadowOpacity = 0.3;
        _rightButton.layer.shadowOffset = CGSizeMake(0, 4);

    }
    return _rightButton;
}
@end

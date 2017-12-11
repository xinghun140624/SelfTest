//
//  HCRefreshHeader.m
//  HongCai
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRefreshHeader.h"
#import <JSCategories/UIButton+ImageTitleStyle.h>
#import <Masonry/Masonry.h>
#import "NSBundle+HCRefreshModule.h"
@interface HCRefreshHeader ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *middleButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation HCRefreshHeader


#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    self.arrowView.image = nil;
    self.lastUpdatedTimeLabel.hidden = YES;
    // 设置控件的高度
    self.mj_h = 110;
    self.stateLabel.textColor = [UIColor colorWithRed:212.0/255.0 green:210.0/255.0  blue:210.0/255.0  alpha:1];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.leftButton];
    [self addSubview:self.middleButton];
    [self addSubview:self.rightButton];
    NSArray * buttonArray = @[self.leftButton,self.middleButton,self.rightButton];
    
    [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:90 leadSpacing:20 tailSpacing:20];
    
    [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        
    }];
    [_leftButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
    [_rightButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
    
    [_middleButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
}


- (void)placeSubviews
{
    
    
    [super placeSubviews];
    self.stateLabel.frame = CGRectMake(0, 20, CGRectGetWidth(self.bounds), 30);
    


    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
    
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        arrowCenterX -= textWidth / 2 + self.labelLeftInset;
    }
    
    CGPoint arrowCenter = CGPointMake(arrowCenterX, 33);

    
    UIView * view = [self valueForKey:@"loadingView"];
    
    // 圈圈
    if (view.constraints.count == 0) {
        view.center = arrowCenter;
    }
    
}



- (UIButton *)leftButton {
	if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setImage:[NSBundle refresh_ImageWithName:@"xlsx_icon_Alrz_nor"] forState:UIControlStateNormal];
        [_leftButton setTitle:@"国有企业\nA轮亿元投资" forState:UIControlStateNormal];
        _leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _leftButton.titleLabel.numberOfLines = 2;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_leftButton setTitleColor:[UIColor colorWithRed:212.0/255.0 green:210.0/255.0  blue:210.0/255.0  alpha:1] forState:UIControlStateNormal];

	}
	return _leftButton;
}
- (UIButton *)middleButton {
	if (!_middleButton) {
        _middleButton = [[UIButton alloc] init];
        [_middleButton setImage:[NSBundle refresh_ImageWithName:@"xlsx_icon_bjwd_nor"] forState:UIControlStateNormal];
        [_middleButton setTitle:@"北京网贷行业协会\n观察员单位" forState:UIControlStateNormal];
        _middleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _middleButton.titleLabel.numberOfLines = 2;
        _middleButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_middleButton setTitleColor:[UIColor colorWithRed:212.0/255.0 green:210.0/255.0  blue:210.0/255.0  alpha:1]forState:UIControlStateNormal];

	}
	return _middleButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setImage:[NSBundle refresh_ImageWithName:@"xlsx_icon_hkyh_nor"] forState:UIControlStateNormal];
        [_rightButton setTitle:@"海口银行\n资金存管" forState:UIControlStateNormal];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightButton.titleLabel.numberOfLines = 2;
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_rightButton setTitleColor:[UIColor colorWithRed:212.0/255.0 green:210.0/255.0  blue:210.0/255.0  alpha:1] forState:UIControlStateNormal];

    }
    return _rightButton;
}
@end

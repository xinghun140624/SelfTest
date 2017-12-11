//
//  HCBoundsTRansferDetailHeaderView.m
//  HongCai
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCreditorTRansferDetailHeaderView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <JSCategories/UIButton+ImageTitleStyle.h>
#import "NSBundle+HCInvestModule.h"
@interface HCCreditorTRansferDetailHeaderView ()
@property (nonatomic, strong, readwrite) UILabel *topLabel;
@property (nonatomic, strong, readwrite) UILabel *descLabel;

@property (nonatomic, strong, readwrite) UIButton *transferAmountButton;
@property (nonatomic, strong, readwrite) UIButton *projectTimeButton;

@end

@implementation HCCreditorTRansferDetailHeaderView


- (void)setInterestRateNumber:(NSNumber *)interestRateNumber {
    _interestRateNumber = interestRateNumber;
    NSString * interestRateString = [NSString stringWithFormat:@"%.2f",interestRateNumber.doubleValue];
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:interestRateString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:64.f]}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" %" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:33]}]];
    self.topLabel.attributedText = str;
}
- (void)setTimeNumber:(NSNumber *)timeNumber {
    _timeNumber =timeNumber;
    [self.projectTimeButton setTitle:[NSString stringWithFormat:@"%@天项目期",timeNumber.stringValue] forState:UIControlStateNormal];
    [self.projectTimeButton setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:5.f];
}
- (void)setMoneyNumber:(NSNumber *)moneyNumber {
    _moneyNumber = moneyNumber;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"转让金额 元" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x333333"]}];
    if (moneyNumber!=nil) {
        [str insertAttributedString:[[NSAttributedString alloc] initWithString:moneyNumber.stringValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xfdb62b"]}] atIndex:5];
        
        [self.transferAmountButton setAttributedTitle:str forState:UIControlStateNormal];
        [self.transferAmountButton setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:5.f];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.transferAmountButton];
        [self addSubview:self.projectTimeButton];
        [self layout_Masonry];
        
        
    }
    return self;
}
- (void)layout_Masonry {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25.f);
        make.centerX.mas_equalTo(self);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(0);
        make.centerX.mas_equalTo(self);
    }];
    [self.transferAmountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(30.f);
    }];
    [self.projectTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.transferAmountButton);
    }];
    [self.transferAmountButton setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:5.f];
    [self.projectTimeButton setButtonImageTitleStyle:ButtonImageTitleStyleLeft padding:5.f];

}
- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:64.f];
        _topLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _topLabel;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"期望年均回报率";
        _descLabel.font = [UIFont systemFontOfSize:10.5];
        _descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _descLabel;
}
- (UIButton *)transferAmountButton {
    if (!_transferAmountButton) {
        _transferAmountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transferAmountButton setImage:[NSBundle invest_ImageWithName:@"xmxq_icon_qd_nor"] forState:UIControlStateNormal];
        _transferAmountButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _transferAmountButton.userInteractionEnabled = NO;
    }
    return _transferAmountButton;
}
- (UIButton *)projectTimeButton {
    if (!_projectTimeButton) {
        _projectTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_projectTimeButton setImage:[NSBundle invest_ImageWithName:@"xmxq_icon_xmqx_nor"] forState:UIControlStateNormal];
        _projectTimeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_projectTimeButton setTitleColor:[UIColor colorWithHexString:@"0x333333"] forState:UIControlStateNormal];
        _projectTimeButton.userInteractionEnabled = NO;
    }
    return _projectTimeButton;
}
@end

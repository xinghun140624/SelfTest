//
//  HCInvestmentConfirmHeaderView.m
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGoToInvestConfirmHeaderView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCGoToInvestConfirmHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;

@end

@implementation HCGoToInvestConfirmHeaderView
- (void)setMoneyNumber:(NSNumber *)moneyNumber {
    _moneyNumber = moneyNumber;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"投资金额：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    NSString * str = [NSString stringWithFormat:@"%.2f元",[moneyNumber floatValue]];
    NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]}];
    [attr appendAttributedString:attr2];
    self.titleLabel.attributedText = attr;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        [self addSubview:self.topLine];
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)-30.f);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];

    }
    return _titleLabel;
}
- (UIView*)topLine {
    if (!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    }
    return _topLine;
}
@end

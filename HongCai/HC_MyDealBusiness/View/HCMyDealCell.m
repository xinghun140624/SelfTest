//
//  HCMyDealCell.m
//  HC_MyDealBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyDealCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMyDealModel.h"
#import "HCTimeTool.h"

@interface HCMyDealCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *timeLabel;



@end

@implementation HCMyDealCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.balanceLabel];
        [self.contentView addSubview:self.timeLabel];
        [self layout_Masonry];
    }
    return self;
}
- (void)setModel:(HCMyDealModel *)model {
    _model = model;
    [NSString stringWithFormat:@"%@",model.successTime];

    self.timeLabel.text = [HCTimeTool getDateWithTimeInterval:model.successTime andTimeFormatter:@"yyyy-MM-dd"];
    self.balanceLabel.text =[NSString stringWithFormat:@"余额：%.2f元",[model.balance doubleValue]];
    self.titleLabel.text = model.dealTypeDesc;
    if ([model.payType integerValue]==1){
        
        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f元",[model.getAmount doubleValue]];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"0xfc4145"];
    }else if ([model.payType integerValue]==2) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f元",[model.payAmount doubleValue]];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"0x86BF58"];
        
    }
}

- (void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(20.f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-10.f);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-20.f);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.moneyLabel);
    }];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font =[UIFont systemFontOfSize:15.f];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _titleLabel;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font =[UIFont systemFontOfSize:14.f];
    }
    return _moneyLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font =[UIFont systemFontOfSize:12.f];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _timeLabel;
}
- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.font =[UIFont systemFontOfSize:12.f];
        _balanceLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _balanceLabel;
}
@end

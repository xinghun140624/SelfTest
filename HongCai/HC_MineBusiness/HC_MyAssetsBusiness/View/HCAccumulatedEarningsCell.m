//
//  HCAccumulatedEarningsCell.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAccumulatedEarningsCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMyDealModel.h"
#import "HCTimeTool.h"

@interface HCAccumulatedEarningsCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation HCAccumulatedEarningsCell
- (void)setModel:(HCMyDealModel *)model {
    _model = model;
    self.titleLabel.text = model.desc;
    self.timeLabel.text = [HCTimeTool getDateWithTimeInterval:model.getTime andTimeFormatter:@"yyyy-MM-dd"];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[model.amount doubleValue]];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.moneyLabel];
        UIView * bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xefefef"];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(20.f);
            make.right.mas_equalTo(-20.f);
            make.height.mas_equalTo(0.5);
        }];

        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(12.f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10.f);
        make.left.mas_equalTo(self.titleLabel);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:15.f];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _timeLabel;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont systemFontOfSize:15.f];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _moneyLabel;
}
@end

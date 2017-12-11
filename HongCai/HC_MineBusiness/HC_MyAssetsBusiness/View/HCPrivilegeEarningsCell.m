//
//  HCPrivilegeEarningsCell.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCPrivilegeEarningsCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMyDealModel.h"
#import "HCTimeTool.h"
@interface HCPrivilegeEarningsCell ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation HCPrivilegeEarningsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.moneyLabel];
        
        [self layout_Masonry];
        UIView * bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(20.f);
            make.right.mas_equalTo(-20.f);
            make.height.mas_equalTo(0.5);
        }];

    }
    return self;
}
- (void)setModel:(HCMyDealModel *)model {
    _model = model;
    self.timeLabel.text = [HCTimeTool getDateWithTimeInterval:model.successTime andTimeFormatter:@"yyyy-MM-dd"];
    if ([model.payType integerValue]==1){
        
        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f元",[model.getAmount doubleValue]];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"0xfc4145"];
    }else if ([model.payType integerValue]==2) {
        self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f元",[model.payAmount doubleValue]];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"0x86BF58"];
        
    }
}
- (void)layout_Masonry {

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
    }];
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
        _moneyLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _moneyLabel;
}


@end

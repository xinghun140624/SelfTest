//
//  HCSpecialMoneyCell.m
//  HongCai
//
//  Created by Candy on 2017/7/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMySpecialMoneyCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCTimeTool.h"
@interface HCMySpecialMoneyCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView * timeImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation HCMySpecialMoneyCell
- (void)setModel:(HCMyPrivilegedCapitalModel *)model {
    _model = model;
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    if (model.amount.stringValue.length>0) {
        NSAttributedString * moneyStr = [[NSAttributedString alloc] initWithString:model.amount.stringValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}];
        [string appendAttributedString:moneyStr];
        self.moneyLabel.attributedText = string;
    }

    self.descLabel.text = [NSString stringWithFormat:@"有效期至%@",[HCTimeTool getDateWithTimeInterval:model.dueTime andTimeFormatter:@"yyyy-MM-dd"]];
    self.titleLabel.text = model.desc;
    self.timeLabel.text = [HCTimeTool getDateWithTimeInterval:model.createTime andTimeFormatter:@"yyyy-MM-dd"];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.moneyLabel];
        [self.bgImageView addSubview:self.titleLabel];
        [self.bgImageView addSubview:self.descLabel];
        [self.bgImageView addSubview:self.line];
        [self.bgImageView addSubview:self.timeImageView];
        [self.bgImageView addSubview:self.timeLabel];
        [self layout_Masonry];
    }
    return self;
}

- (void)layout_Masonry {
    
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)-40;
    
    CGFloat height = width*217.0/616.0;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
    }];

    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(width/2.0);
        make.top.mas_equalTo(height *0.20);
        
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.top.mas_equalTo(self.moneyLabel);
        make.bottom.mas_equalTo(self.moneyLabel);
        make.width.mas_equalTo(0.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line).mas_offset(15.f);
        make.top.mas_equalTo(self.line);
        make.right.mas_equalTo(0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.line);
    }];
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.bottom.mas_equalTo(-height*0.08);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeImageView.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(self.timeImageView);
    }];
}
- (UIImageView*)bgImageView {
    if (!_bgImageView){
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdtqbj_bg_tqbj_nor"]];
    }
    return _bgImageView;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    }
    return _line;
}
-(UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"0xFF4249"];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _titleLabel;
}
-(UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _descLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
    }
    return _timeLabel;
}
- (UIImageView*)timeImageView {
    if (!_timeImageView){
        _timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdtqbj_icon_time_w_nor"]];
    }
    return _timeImageView;
}


@end


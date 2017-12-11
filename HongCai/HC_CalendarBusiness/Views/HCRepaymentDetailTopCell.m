//
//  HCRepaymentDetailTopCell.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRepaymentDetailTopCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCRepaymentDetailTopCell ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * moneyLabel;

@end
@implementation HCRepaymentDetailTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(20);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(20);
            make.centerY.mas_equalTo(self.contentView);
        }];
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _titleLabel;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"0xff6000"];
        _moneyLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _moneyLabel;
}

@end


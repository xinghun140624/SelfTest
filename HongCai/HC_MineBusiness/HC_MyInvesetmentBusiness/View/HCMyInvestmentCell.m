//
//  HCMyInvestmentCell.m
//  HongCai
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyInvestmentCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+HCMyInvesetmentModule.h"
@interface HCMyInvestmentCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation HCMyInvestmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.amountLabel];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(15.f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.bottom.mas_offset(-15.f);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descLabel.mas_right);
        make.centerY.mas_equalTo(self.descLabel);
        make.right.mas_equalTo(-10);
    }];
}
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _amountLabel.font = [UIFont systemFontOfSize:15];
    }
    return _amountLabel;
}
- (UILabel *)descLabel {
    if(!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _descLabel.font = [UIFont systemFontOfSize:15];
        _descLabel.text = @"待收本金：";
        [_descLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _descLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
@end

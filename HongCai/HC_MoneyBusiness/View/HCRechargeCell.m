//
//  HCRechargeCell.m
//  HongCai
//
//  Created by Candy on 2017/6/13.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRechargeCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

#import <Masonry/Masonry.h>


@implementation HCRechargeTopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.accountBalanceLabel];
        [self.accountBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel*)accountBalanceLabel {
    if (!_accountBalanceLabel){
        _accountBalanceLabel = [[UILabel alloc] init];
        _accountBalanceLabel.font =[UIFont systemFontOfSize:14.f];
        _accountBalanceLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _accountBalanceLabel;
}
@end


@implementation HCRechargeBankCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.bankIconView];
        [self.contentView addSubview:self.bankAccountLabel];
        [self.contentView addSubview:self.bankNameLabel];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    [self.bankIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33.f);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bankIconView.mas_right).mas_equalTo(33.f);
        make.top.mas_equalTo(24.f);
    }];
    [self.bankAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bankNameLabel.mas_bottom).mas_equalTo(10.f);
        make.left.mas_equalTo(self.bankNameLabel);
    }];
}

- (UIImageView *)bankIconView {
    if (!_bankIconView) {
        _bankIconView = [[UIImageView alloc] init];
    }
    return _bankIconView;
}
- (UILabel*)bankNameLabel {
    if (!_bankNameLabel){
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.font = [UIFont systemFontOfSize:14];
        _bankNameLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _bankNameLabel;
}

- (UILabel*)bankAccountLabel {
    if (!_bankAccountLabel){
        _bankAccountLabel = [[UILabel alloc] init];
        _bankAccountLabel.font = [UIFont systemFontOfSize:14];
        _bankAccountLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _bankAccountLabel;
}
@end



@interface HCRechargeInputCell()<UITextFieldDelegate>

@end

@implementation HCRechargeInputCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.jinELabel];
        [self.contentView addSubview:self.rechargeTextField];
        [self layout_Masonry];
        
    }
    return self;
}
- (void)layout_Masonry {
    [self.jinELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.rechargeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.jinELabel.mas_centerY);
        make.left.mas_equalTo(self.jinELabel.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(40.f);
    }];
}
- (UILabel *)jinELabel {
    if (!_jinELabel) {
        UILabel * jinELabel = [[UILabel alloc] init];
        jinELabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        jinELabel.font = [UIFont systemFontOfSize:14.f];
        [jinELabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        _jinELabel = jinELabel;
    }
    return _jinELabel;
}
- (UITextField *)rechargeTextField {
    if (!_rechargeTextField) {
        _rechargeTextField = [[UITextField alloc] init];
        _rechargeTextField.borderStyle = UITextBorderStyleNone;
        _rechargeTextField.keyboardType = UIKeyboardTypeDecimalPad;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入充值金额" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _rechargeTextField.attributedPlaceholder = placeholderText;
        _rechargeTextField.font = [UIFont systemFontOfSize:12];
        _rechargeTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _rechargeTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _rechargeTextField.delegate = self;
    }
    return _rechargeTextField;
}
@end

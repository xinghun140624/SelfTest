//
//  HCBankManagerTopCell.m
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCBankManagerTopCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

@interface HCBankManagerTopCell ()
@property (nonatomic, strong) UIImageView *bankIconView;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *bankAccountLabel;
@end

@implementation HCBankManagerTopCell

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
        make.size.mas_equalTo(CGSizeMake(47, 47));
        make.top.mas_equalTo(15.f);
        make.bottom.mas_equalTo(-15.f);
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



@interface HCBankManagerMobileCell ()
@property (nonatomic, strong) UILabel * mobileLabel;
@property (nonatomic, strong) UILabel * bankLabel;
@property (nonatomic, strong) UIButton * modifyButton;

@end

@implementation HCBankManagerMobileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bankLabel];
        [self.contentView addSubview:self.mobileLabel];
        [self.contentView addSubview:self.modifyButton];
        
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    self.bankLabel.text = @"银行预留手机号";
    
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(20.f);
        make.bottom.mas_equalTo(-20.f);
    }];
    
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.bankLabel);
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.modifyButton.mas_left).mas_offset(-15);
        make.centerY.mas_equalTo(self.modifyButton);
    }];
    
    
}
- (void)modifyButtonClick {
    if (self.modifyButtonClickCallBack) {
        self.modifyButtonClickCallBack();
    }
}
- (UILabel *)bankLabel {
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc] init];
        _bankLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _bankLabel.font = [UIFont systemFontOfSize:14];
    }
    return _bankLabel;
}

- (UILabel *)mobileLabel {
    if (!_mobileLabel) {
        _mobileLabel = [[UILabel alloc] init];
        _mobileLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _mobileLabel.font = [UIFont systemFontOfSize:15];
    }
    return _mobileLabel;
}
- (UIButton *)modifyButton {
    if (!_modifyButton) {
        _modifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _modifyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        [_modifyButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyButton;
}
@end

@interface HCBankManagerJieBangCell ()

@property (nonatomic, strong) UIButton * jiebangButton;

@end

@implementation HCBankManagerJieBangCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.jiebangButton];

        
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
 
    
    [self.jiebangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
        make.height.mas_equalTo(45).priorityHigh();
    }];
    

    
    
}
- (void)jiebangButtonClick:(UIButton *)button {
    if (self.jiebangButtonClickCallBack) {
        self.jiebangButtonClickCallBack();
    }
}
- (UIButton *)jiebangButton {
    if (!_jiebangButton) {
        _jiebangButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _jiebangButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_jiebangButton setTitle:@"解绑银行卡" forState:UIControlStateNormal];
        [_jiebangButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        [_jiebangButton addTarget:self action:@selector(jiebangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jiebangButton;
}
@end

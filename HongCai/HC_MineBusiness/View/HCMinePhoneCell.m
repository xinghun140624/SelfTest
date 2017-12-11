//
//  HCMinePhoneCell.m
//  HongCai
//
//  Created by Candy on 2017/8/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMinePhoneCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

@interface HCMinePhoneCell ()
@property (nonatomic, strong) UIButton * phoneButton;
@end

@implementation HCMinePhoneCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self.contentView addSubview:self.phoneButton];
        [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)phoneButtonClick {
    NSURL * URL = [NSURL URLWithString:@"tel://4009907626"];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        if ([[UIDevice currentDevice].systemVersion floatValue]>=10.0) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:NULL];
        }else{
            [[UIApplication sharedApplication] openURL:URL];
        }
    }
}

- (UIButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_phoneButton setTitle:@"联系客服：400-990-7626" forState:UIControlStateNormal];
        _phoneButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_phoneButton setTintColor:[UIColor colorWithHexString:@"0xff611d"]];
        
        [_phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
     

    }
    return _phoneButton;
}
@end

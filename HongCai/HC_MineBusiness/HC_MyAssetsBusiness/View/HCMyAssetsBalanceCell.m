//
//  HCMyAssetsBalanceCell.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyAssetsBalanceCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "NSBundle+MyAssetsModule.h"

@interface   HCMyAssetsBalanceCell()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *usefulBalanceLabel;
@property (nonatomic, strong) UIImageView * usefulBalanceImageView;

@property (nonatomic, strong) UILabel *usefulBalanceDescLabel;

@end



@implementation HCMyAssetsBalanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];

        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.usefulBalanceLabel];
        [self.bgImageView addSubview:self.usefulBalanceImageView];
        [self.bgImageView addSubview:self.usefulBalanceDescLabel];

        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(30, 0, 0, 0));
        }];
        [self.usefulBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.bgImageView).mas_offset(CGPointMake(0, -20));
        }];
        [self.usefulBalanceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.usefulBalanceLabel.mas_bottom).mas_offset(5.f);
            make.centerX.mas_equalTo(self.bgImageView.mas_centerX).mas_offset(20.f);
        }];
        [self.usefulBalanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.usefulBalanceDescLabel.mas_centerY);
            make.right.mas_equalTo(self.usefulBalanceDescLabel.mas_left).mas_offset(-4.f);
        }];
       
    }
    return self;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [NSBundle myAssets_ImageWithName:@"zhzl_ibg_kyye_nor"];
    }
    return _bgImageView;
}

- (UIImageView *)usefulBalanceImageView {
    if (!_usefulBalanceImageView) {
        _usefulBalanceImageView = [[UIImageView alloc] init];
        _usefulBalanceImageView.image = [NSBundle myAssets_ImageWithName:@"zhzl_icon_kyye_nor"];
    }
    return _usefulBalanceImageView;
}

- (UILabel *)usefulBalanceLabel {
    if (!_usefulBalanceLabel) {
        _usefulBalanceLabel = [[UILabel alloc] init];
        _usefulBalanceLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _usefulBalanceLabel.font = [UIFont systemFontOfSize:47.f];
        _usefulBalanceLabel.textAlignment = NSTextAlignmentCenter;
        _usefulBalanceLabel.text = @"0.00";
    }
    return _usefulBalanceLabel;
}
- (UILabel *)usefulBalanceDescLabel {
    if (!_usefulBalanceDescLabel) {
        _usefulBalanceDescLabel = [[UILabel alloc] init];
        _usefulBalanceDescLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _usefulBalanceDescLabel.numberOfLines = 0;
        _usefulBalanceDescLabel.font = [UIFont systemFontOfSize:14.f];

        _usefulBalanceDescLabel.textAlignment = NSTextAlignmentCenter;
        _usefulBalanceDescLabel.text = @"可用余额（元）";
    }
    return _usefulBalanceDescLabel;
}
@end

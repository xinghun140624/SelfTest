//
//  HCMyAssetsEarningsCell.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyAssetsEarningsCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "NSBundle+MyAssetsModule.h"

@interface HCMyAssetsEarningsCell ()
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;


@end

@implementation HCMyAssetsEarningsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];

        [self layout_Masonry];
        self.iconView.backgroundColor = [UIColor colorWithHexString:@"0x478bc5"];
    }
    return self;
}

- (void)layout_Masonry {

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11, 11));
        make.left.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(15.f);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
  
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
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
- (UIView *)iconView {
    if (!_iconView) {
        _iconView = [[UIView alloc] init];
        _iconView.layer.cornerRadius = 5.5f;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _descLabel.font = [UIFont systemFontOfSize:15];
    }
    return _descLabel;
}
@end


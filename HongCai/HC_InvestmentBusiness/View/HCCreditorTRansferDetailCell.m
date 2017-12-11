//
//  HCBoundsTRansferDetailCell.m
//  HongCai
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCreditorTRansferDetailCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>


@interface HCCreditorTRansferDetailCell ()
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *contentLabel;
@property (nonatomic, strong, readwrite) UIView *bottomLine;

@end

@implementation HCCreditorTRansferDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self addSubview:self.bottomLine];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _contentLabel;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    }
    return _bottomLine;
}
@end

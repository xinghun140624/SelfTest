
//
//  HCSettingCell.m
//  HongCai
//
//  Created by Candy on 2017/6/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSettingCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+HCSettingModule.h"
@interface HCSettingCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation HCSettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.top.mas_equalTo(15.f);
            make.centerY.mas_equalTo(self.contentView);
        }];
 
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
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

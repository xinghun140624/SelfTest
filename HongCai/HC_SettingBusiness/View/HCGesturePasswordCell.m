//
//  HCGesturePasswordCell.m
//  HongCai
//
//  Created by Candy on 2017/8/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGesturePasswordCell.h"


#import "HCPasswordCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>

@interface HCGesturePasswordCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UISwitch * mySwitch;
@end
@implementation HCGesturePasswordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bottomLine];
        [self.contentView addSubview:self.mySwitch];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.centerY.mas_equalTo(self.contentView);
        }];
 
        [self.mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(self.titleLabel);
        }];
    }
    return self;
}
- (UISwitch *)mySwitch {
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] init];
    }
    return _mySwitch;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xefefef"];
    }
    return _bottomLine;
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

@end

//
//  HCCalendarBottomCell.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/25.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCalendarBottomCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
@interface HCCalendarBottomCell ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * moneyLabel;
@end

@implementation HCCalendarBottomCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(15.f);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

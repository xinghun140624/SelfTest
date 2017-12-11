//
//  HCSpecialInvestCell.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSpecialInvestCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

@implementation HCSpecialInvestSpaceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setupHeight:(CGFloat)height {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height).priorityHigh();
    }];
    [self layoutIfNeeded];
}
@end


@interface HCSpecialInvestCell ()
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIImageView * checkImageView;
@end


@implementation HCSpecialInvestCell
- (void)setRuleModel:(HCSpecialInvestRuleModel *)ruleModel {
    _ruleModel = ruleModel;
    
    self.titleLabel.text = ruleModel.desc;
    self.descLabel.text = [NSString stringWithFormat:@"投资≥%d元",ruleModel.minInvestAmount.intValue];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgImageView];
        self.contentView.backgroundColor =  [UIColor colorWithHexString:@"0xefeef4"];

        [self.bgImageView addSubview:self.titleLabel];
        [self.bgImageView addSubview:self.descLabel];
        [self.bgImageView addSubview:self.checkImageView];
        [self.bgImageView addSubview:self.iconImageView];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    
    CGFloat height = (CGRectGetWidth([UIScreen mainScreen].bounds)-40)*162.0/664.0;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.f);
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.height.mas_equalTo(self.bgImageView.mas_width).multipliedBy(162.0/664.0).priorityHigh();
        make.bottom.mas_equalTo(0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.iconImageView.superview);
    }];
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(height*0.15);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-height*0.08);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.checkImageView.hidden = !selected;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tqtz-bg-xcq-nor"]];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)descLabel {
    if(!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor grayColor];
        _descLabel.font = [UIFont systemFontOfSize:13];
    }
    return _descLabel;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-cst-nor"]];
        [_iconImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _iconImageView;
}
- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tqtz_iocn_click_nor"]];
        _checkImageView.hidden = YES;
    }
    return _checkImageView;
}
@end

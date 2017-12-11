//
//  HCGoToInvestCouponCell.m
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGoToInvestCouponCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "NSBundle+GoToInvestModule.h"
#import "HCTimeTool.h"
#import "HCGoToInvestCouponModel.h"

@interface HCGoToInvestCouponCell  ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) UILabel *rateDaysLabel;

@end

@implementation HCGoToInvestCouponCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgImageView];
        
        [self.bgImageView addSubview:self.typeLabel];
        [self.bgImageView addSubview:self.titleLabel];
        [self.bgImageView addSubview:self.descLabel];
        [self.bgImageView addSubview:self.rateDaysLabel];
        [self.bgImageView addSubview:self.iconImageView];
        [self.bgImageView addSubview:self.timeLabel];
        [self.bgImageView addSubview:self.checkImageView];
        
        
        [self layout_Masonry];
        
    }
    return self;
}

- (void)setModel:(HCGoToInvestCouponModel *)model {
    _model = model;
 
    _checkImageView.hidden = !model.isSelected;

    NSString * createTime = [HCTimeTool getDateWithTimeInterval:model.createTime andTimeFormatter:@"yyyy.MM.dd"];
    NSString * endTime = [HCTimeTool getDateWithTimeInterval:model.endTime andTimeFormatter:@"yyyy.MM.dd"];
    
    
    if ([HCTimeTool getTimeDistanceDate1:model.createTime.integerValue date2:model.endTime.integerValue]==0) {
        //有效期为1天;
        self.timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",endTime];
    }else {
        self.timeLabel.text = [NSString stringWithFormat:@"有效期：%@-%@",createTime,endTime];
        
    }

    if ([model.type integerValue]==1) {
        //加息
        if ([self.investAmount integerValue] >= [model.minInvestAmount integerValue]) {
            self.bgImageView.image = [NSBundle goToInvest_ImageWithName:@"yhq_bg_jxq_nor"];
        }else{
            self.bgImageView.image = [NSBundle goToInvest_ImageWithName:@"yhq_bg_jxq_bkx_nor"];

        }
        self.titleLabel.text = [NSString stringWithFormat:@"%@%%",model.value];
        if ([model.minInvestAmount integerValue]<=0) {
            self.descLabel.text = [NSString stringWithFormat:@"投资任意金额可用"];
        }else{
            self.descLabel.text = [NSString stringWithFormat:@"投资金额≥%zd可使用",[model.minInvestAmount integerValue]];
        }
        self.typeLabel.text = @"加息券";
        if (model.duration.integerValue == -1) {
            self.rateDaysLabel.text = @"加息天数：全程加息";
        }else if (model.duration.integerValue >0) {
            self.rateDaysLabel.text = [NSString stringWithFormat:@"加息天数：%zd天",model.duration.integerValue];
        }
    }else if ([model.type integerValue]==2){
        //现金券
        self.typeLabel.text = @"现金券";
        self.rateDaysLabel.text = @"";
        
        if ([self.investAmount integerValue] >= [model.minInvestAmount integerValue]) {
            self.bgImageView.image = [NSBundle goToInvest_ImageWithName:@"yhq_bg_xjq_nor"];
        }else{
            self.bgImageView.image = [NSBundle goToInvest_ImageWithName:@"yhq_bg_xjq_blx_nor"];
            
        }
        
        self.titleLabel.text = [NSString stringWithFormat:@"¥%zd",[model.value integerValue]];
        if ([model.minInvestAmount integerValue]<=0) {
            self.descLabel.text = [NSString stringWithFormat:@"投资任意金额可用"];
        }else{
            self.descLabel.text = [NSString stringWithFormat:@"投资金额≥%zd可使用",[model.minInvestAmount integerValue]];
        }
    }
    
    
}
- (void)layout_Masonry {
    
    
    CGFloat height = (CGRectGetWidth([UIScreen mainScreen].bounds) -40)*162.0/664.0;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.f);
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.height.mas_equalTo(self.bgImageView.mas_width).multipliedBy(162.0/664.0);
    }];
    
    CGSize typeSize = [@"加息券" sizeWithAttributes:@{NSForegroundColorAttributeName:[UIFont systemFontOfSize:9.5]}];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2.5f);
        make.top.mas_equalTo(10.f);
        make.width.mas_equalTo(typeSize.width+5);
        make.height.mas_equalTo(typeSize.height+2.f);
        self.typeLabel.layer.cornerRadius = (typeSize.height+2.f)*0.5;
        self.typeLabel.layer.masksToBounds = YES;
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50.f);
        make.top.mas_equalTo(height*0.12);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(height*0.18);
    }];
    [self.rateDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.left.mas_equalTo(self.descLabel);
        make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(height*0.08);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.5f);
        make.bottom.mas_equalTo(-height*0.08);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImageView);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(6.f);
    }];
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
    }];
    
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:9.5];
        _typeLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:28.5];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:12.f];
        _descLabel.textColor = [UIColor whiteColor];
    }
    return _descLabel;
}
- (UILabel *)rateDaysLabel {
    if (!_rateDaysLabel) {
        _rateDaysLabel = [[UILabel alloc] init];
        _rateDaysLabel.font= [UIFont systemFontOfSize:12.f];
        _rateDaysLabel.textColor = [UIColor whiteColor];
    }
    return _rateDaysLabel;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[NSBundle goToInvest_ImageWithName:@"yhq_iocn_time_nor"]];
    }
    return _iconImageView;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:9.5];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _timeLabel;
}
- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView =[[UIImageView alloc] initWithImage:[NSBundle goToInvest_ImageWithName:@"yhq_iocn_click_nor"]];
        _checkImageView.hidden = YES;
    }
    return _checkImageView;
}
@end

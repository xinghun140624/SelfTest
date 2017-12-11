//
//  HCMyHistoryCouponCell.m
//  HongCai
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyHistoryCouponCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMyCouponModel.h"
#import "HCTimeTool.h"
#import "NSBundle+HCMyCouponModule.h"

@interface HCMyHistoryCouponCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *interestRateLabel;
@property (nonatomic, strong) UILabel *invesetmentNameLabel;
@property (nonatomic, strong) UILabel *userConditionsLabel;
@property (nonatomic, strong) UILabel *increaseRateLabel;//加息时间

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *rateDaysLabel;
@end

@implementation HCMyHistoryCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgImageView];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        
        [self.bgImageView addSubview:self.typeLabel];
        [self.bgImageView addSubview:self.titleLabel];
        [self.bgImageView addSubview:self.invesetmentNameLabel];
        [self.bgImageView addSubview:self.userConditionsLabel];
        [self.bgImageView addSubview:self.interestRateLabel];
        [self.bgImageView addSubview:self.rateDaysLabel];
        [self.bgImageView addSubview:self.iconImageView];
        [self.bgImageView addSubview:self.timeLabel];
        [self.bgImageView addSubview:self.statusImageView];
        [self layout_Masonry];
  
    }
    return self;
}
- (void)setModel:(HCMyCouponModel *)model {
    _model = model;
    self.titleLabel.text = model.desc;
    
    NSString * createTime = [HCTimeTool getDateWithTimeInterval:model.createTime andTimeFormatter:@"yyyy.MM.dd"];
    NSString * endTime = [HCTimeTool getDateWithTimeInterval:model.endTime andTimeFormatter:@"yyyy.MM.dd"];
    if ([HCTimeTool getTimeDistanceDate1:model.createTime.integerValue date2:model.endTime.integerValue]==0) {
        //有效期为1天;
        self.timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",endTime];
    }else {
        self.timeLabel.text = [NSString stringWithFormat:@"有效期：%@-%@",createTime,endTime];
        
    }
    
    NSArray *typeName = [model.investProductType componentsSeparatedByString:@","];
    
    __block NSMutableString * invesetmentName = [NSMutableString new];
    if (typeName.count>1) {
        [typeName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"5"]) {
                [invesetmentName appendString:@"宏财精选"];
            }else if ([obj isEqualToString:@"6"]){
                [invesetmentName appendString:@"、宏财尊贵"];
            }
        }];
    }else{
        NSString * string = typeName.firstObject;
        if ([string isEqualToString:@"5"]) {
            [invesetmentName appendString:@"宏财精选"];
        }else if ([string isEqualToString:@"6"]){
            [invesetmentName appendString:@"宏财尊贵"];
        }
    }
    self.invesetmentNameLabel.text =[NSString stringWithFormat:@"投资产品：%@",invesetmentName] ;
    
    if ([model.minInvestAmount integerValue]>0) {
        self.userConditionsLabel.text = [NSString stringWithFormat:@"使用条件：投资≥%zd元",[model.minInvestAmount integerValue]];
        
    }else{
        self.userConditionsLabel.text = @"使用条件：投资任意金额可用";
    }
    if ([model.type integerValue]==1) {
        //加息
        self.bgImageView.image = [NSBundle couponBusiness_ImageWithName:@"wdjxq_bg_sxjxq_nor"];
        self.typeLabel.text = @"加息券";
        if (model.value.stringValue) {
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:model.value.stringValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}];
            
            NSAttributedString * moneyStr = [[NSAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            
            [string appendAttributedString:moneyStr];
            self.interestRateLabel.attributedText = string;
        }
        
        if (model.duration.integerValue == -1) {
            self.rateDaysLabel.text = @"加息天数：全程加息";
        }else if (model.duration.integerValue >0) {
            self.rateDaysLabel.text = [NSString stringWithFormat:@"加息天数：%zd天",model.duration.integerValue];
        }
    }else if ([model.type integerValue]==5){
        //特权加息
        self.bgImageView.image = [NSBundle couponBusiness_ImageWithName:@"wdjxq_bg_sxjxq_nor"];
        self.typeLabel.text = @"加息券";
        if (model.value.stringValue) {
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:model.value.stringValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}];
            
            NSAttributedString * moneyStr = [[NSAttributedString alloc] initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            
            [string appendAttributedString:moneyStr];
            self.interestRateLabel.attributedText = string;
        }
        self.rateDaysLabel.text = @"加息天数：1天";
    }else if ([model.type integerValue]==2){
        //现金券
        self.typeLabel.text = @"现金券";
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        if (model.value.stringValue) {
            NSAttributedString * moneyStr = [[NSAttributedString alloc] initWithString:model.value.stringValue attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}];
            
            [string appendAttributedString:moneyStr];
            self.interestRateLabel.attributedText = string;
        }
       
        self.bgImageView.image = [NSBundle couponBusiness_ImageWithName:@"wdjxq_bg_sxxjq_nor"];
    }
    if ([model.status integerValue]==3) {
        //已过期;
        self.statusImageView.image = [NSBundle couponBusiness_ImageWithName:@"wdyhq_icon_ysx_nor"];
    }else{
        self.statusImageView.image = [NSBundle couponBusiness_ImageWithName:@"wdyhq_icon_ysy_nor"];
    }
}
- (void)layout_Masonry {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)-40;
    
    CGFloat height = width*217.0/616.0;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
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
    
    [self.interestRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(width *100.0/616.0);
        make.top.mas_equalTo(height *0.20);
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (CGRectGetWidth([UIScreen mainScreen].bounds)==320) {
            make.width.mas_equalTo(width *340.0/616.0);
        }else {
            make.width.mas_equalTo(width *310.0/616.0);
        }
        make.top.mas_equalTo(height*0.05);
        make.right.mas_equalTo(0);
    }];
    [self.invesetmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(height*0.046);
        make.width.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(0);
    }];
    [self.userConditionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.invesetmentNameLabel.mas_bottom).mas_offset(height*0.046*0.4);
        make.width.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(0);
    }];
    [self.rateDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userConditionsLabel.mas_bottom).mas_offset(height*0.046*0.4);
        make.width.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-height*0.08);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImageView);
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(6.f);
    }];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)-40;
        CGFloat height = width*217.0/616.0;
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
        _bgImageView.userInteractionEnabled = YES;
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
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
    }
    return _titleLabel;
}

- (UILabel *)invesetmentNameLabel {
    if (!_invesetmentNameLabel) {
        _invesetmentNameLabel = [[UILabel alloc] init];
        _invesetmentNameLabel.font = [UIFont systemFontOfSize:10.f];
        _invesetmentNameLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
    }
    return _invesetmentNameLabel;
}

- (UILabel *)userConditionsLabel {
    if (!_userConditionsLabel) {
        _userConditionsLabel = [[UILabel alloc] init];
        _userConditionsLabel.font = [UIFont systemFontOfSize:10.f];
        _userConditionsLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
    }
    return _userConditionsLabel;
}
- (UILabel *)rateDaysLabel {
    if (!_rateDaysLabel) {
        _rateDaysLabel = [[UILabel alloc] init];
        _rateDaysLabel.font= [UIFont systemFontOfSize:10.f];
        _rateDaysLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
    }
    return _rateDaysLabel;
}
- (UILabel *)interestRateLabel {
    if (!_interestRateLabel) {
        _interestRateLabel = [[UILabel alloc] init];
        _interestRateLabel.font = [UIFont systemFontOfSize:33.f];
        _interestRateLabel.textColor = [UIColor whiteColor];
    }
    return _interestRateLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:9.5];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0xbfbfbf"];
    }
    return _timeLabel;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[NSBundle couponBusiness_ImageWithName:@"wdyhq_icon_yxq_nor"]];
    }
    return _iconImageView;
}
- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithImage:[NSBundle couponBusiness_ImageWithName:@"wdyhq_icon_ygq_nor"]];
    }
    return _statusImageView;
}
@end

//
//  HCInvestmentCell.m
//  HongCai
//
//  Created by Candy on 2017/6/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInvestmentCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

#import <Masonry/Masonry.h>
#import "HCAssignmentModel.h"
#import "HCProjectSubModel.h"
@interface HCInvestmentCell()
@property (nonatomic, strong) UILabel *periodLabel;
@property (nonatomic, strong) UIImageView  *iconImageView;
@property (nonatomic, strong) UILabel *statusLabel;
//利率
@property (nonatomic, strong) UILabel *interestRateLabel;
//期限
@property (nonatomic, strong) UILabel *timeLimitLabel;

//剩余金额
@property (nonatomic, strong) UILabel *remainLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end
@implementation HCInvestmentCell
- (void)setFrame:(CGRect)frame {
    CGFloat width = frame.size.width;
    width-=30;
    CGFloat x = frame.origin.x;
    x +=15;
    frame.origin.x = x;
    frame.size.width = width;
    [super setFrame:frame];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.cornerRadius = 12.f;
        self.layer.shadowOffset =  CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.15;
        self.layer.shadowRadius = 18.f;
        
        [self.contentView addSubview:self.periodLabel];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.interestRateLabel];
        [self.contentView addSubview:self.timeLimitLabel];
        [self.contentView addSubview:self.remainLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.middleLabel];
        [self.contentView addSubview:self.rightLabel];
        
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    CGFloat padding = 15.f;
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(padding);
        make.right.mas_lessThanOrEqualTo(self.statusLabel.mas_left);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(self.periodLabel);
        NSString * leftText = @"融资成功";
        CGSize size = [leftText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]}];
        self.statusLabel.layer.cornerRadius = (size.height+4.0)/2.0;
        make.size.mas_equalTo(CGSizeMake(size.width+10, size.height+4));
    }];

  
    [self.interestRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.top.mas_equalTo(self.periodLabel.mas_bottom).mas_offset(24.f);
    }];
    
    [self.timeLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.middleLabel);
        make.centerY.mas_equalTo(self.interestRateLabel).mas_offset(0);
    }];
    
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(self.timeLimitLabel);
    }];
    
    
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.top.mas_equalTo(self.interestRateLabel.mas_bottom).mas_offset(8.f);
        make.bottom.mas_equalTo(-padding);
    }];
    
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.leftLabel);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(self.leftLabel);
    }];
    
}
- (void)setProject:(HCProjectSubModel *)project {
    _project = project;
    self.leftLabel.text =@"期望年均回报率";
    self.middleLabel.text =@"项目期限";
    self.rightLabel.text =@"可投金额";
    self.periodLabel.text = project.name;
    NSString * rateString = [NSString stringWithFormat:@"%.2f%%",[project.annualEarnings floatValue]];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:rateString];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, rateString.length-1)];
    
    self.interestRateLabel.attributedText = attrStr;
    self.timeLimitLabel.text =[NSString stringWithFormat:@"%@天期限",project.projectDays];
    if ([project.status integerValue]==7) {
        self.layer.shadowColor = [UIColor colorWithHexString:@"0xfab513"].CGColor;
        self.remainLabel.text = [NSString stringWithFormat:@"%zd元",[project.amount integerValue]];
        self.periodLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.interestRateLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"0xfdb62b"];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"0xfdb62b"].CGColor;
        self.leftLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.middleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.rightLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.timeLimitLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.remainLabel.textColor = [UIColor colorWithHexString:@"0x666666"];

    }else{
        self.layer.shadowColor = [UIColor colorWithHexString:@"0x39d5c9"].CGColor;
        self.remainLabel.text = @"0元";
        self.periodLabel.textColor = [UIColor colorWithHexString:@"0x999999"];

        self.statusLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"0x999999"].CGColor;
        self.interestRateLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.leftLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.middleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.rightLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.timeLimitLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.remainLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
}
- (void)setAssignment:(HCAssignmentModel *)assignment {
    _assignment = assignment;
    //1 转让中 4 已转让
    
    self.leftLabel.text =@"期望年均回报率";
    self.middleLabel.text =@"剩余期限";
    self.rightLabel.text =@"可投金额";
    if ([assignment.status integerValue]==1) {
        self.statusLabel.text = @"转让中";
        self.layer.shadowColor = [UIColor colorWithHexString:@"0xfab513"].CGColor;
        self.remainLabel.text = [NSString stringWithFormat:@"%zd元",[assignment.currentStock integerValue]*100];
        self.interestRateLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"0xfdb62b"];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"0xfdb62b"].CGColor;
        self.leftLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.middleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.rightLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.timeLimitLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.remainLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        
    }else{
        self.statusLabel.text = @"已转让";
        self.remainLabel.text = @"0元";
        self.layer.shadowColor = [UIColor colorWithHexString:@"0x39d5c9"].CGColor;
        self.interestRateLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.statusLabel.layer.borderColor = [UIColor colorWithHexString:@"0x999999"].CGColor;
        self.leftLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.middleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.rightLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.timeLimitLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.remainLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    self.periodLabel.text = assignment.name;
    
    NSString * rateString = [NSString stringWithFormat:@"%.2f%%",[assignment.annualEarnings floatValue]];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:rateString];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, rateString.length-1)];
    self.interestRateLabel.attributedText = attrStr;
    self.timeLimitLabel.text =[NSString stringWithFormat:@"%@天",assignment.remainDay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel*)periodLabel {
    if (!_periodLabel){
        _periodLabel = [[UILabel alloc] init];
        _periodLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _periodLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _periodLabel;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12.f];
        _statusLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _statusLabel.layer.borderWidth = 1.f;
        _statusLabel.textAlignment=  NSTextAlignmentCenter;
        _statusLabel.layer.borderColor = [UIColor colorWithHexString:@"0xfdb62b"].CGColor;
    }
    return _statusLabel;
}
- (UILabel*)interestRateLabel {
    if (!_interestRateLabel){
        _interestRateLabel = [[UILabel alloc] init];
        _interestRateLabel.font = [UIFont systemFontOfSize:12.f];
        _interestRateLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _interestRateLabel;
}
- (UILabel*)remainLabel {
    if (!_remainLabel){
        _remainLabel = [[UILabel alloc] init];
        _remainLabel.font = [UIFont systemFontOfSize:16];
        _remainLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    }
    return _remainLabel;
}
- (UILabel*)timeLimitLabel {
    if (!_timeLimitLabel){
        _timeLimitLabel = [[UILabel alloc] init];
        _timeLimitLabel.font = [UIFont systemFontOfSize:16];
        _timeLimitLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    }
    return _timeLimitLabel;
}
- (UILabel*)leftLabel {
    if (!_leftLabel){
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:10.5];
        _leftLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _leftLabel;
}
- (UILabel*)middleLabel {
    if (!_middleLabel){
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.font = [UIFont systemFontOfSize:10.5];
        _middleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _middleLabel;
}
- (UILabel*)rightLabel {
    if (!_rightLabel){
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:10.5];
        _rightLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _rightLabel;
}



@end

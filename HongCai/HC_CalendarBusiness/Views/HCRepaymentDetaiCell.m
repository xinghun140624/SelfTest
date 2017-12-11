//
//  HCRepaymentDetaiCell.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRepaymentDetaiCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCCalendarRepaymentDetailModel.h"
#import "NSBundle+HCCalendarModule.h"
#import "HCCalendarRaiseView.h"
@interface HCRepaymentDetaiCell ()
@property (nonatomic, strong) NSDateFormatter * dateFormatter;

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * principalDescLabel;
@property (nonatomic, strong) UILabel * principalMoneyLabel;
@property (nonatomic, strong) UILabel * rateDescLabel;
@property (nonatomic, strong) UILabel * rateMoneyLabel;
@property (nonatomic, strong) UILabel * interestDescLabel;
@property (nonatomic, strong) UILabel * interestMoneyLabel;
@property (nonatomic, strong) UILabel * anticipatePrincipalDescLabel;
@property (nonatomic, strong) UILabel * anticipatePrincipalMoneyLabel;
@property (nonatomic, strong) UILabel * valueDateDescLabel;
@property (nonatomic, strong) UILabel * valueDateLabel;
@property (nonatomic, strong) UILabel * repaymentDateDescLabel;
@property (nonatomic, strong) UILabel * repaymentDateLabel;
@property (nonatomic, strong) HCCalendarRaiseView * raiseView;

@end

@implementation HCRepaymentDetaiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy/MM/dd";
        
        self.contentView.backgroundColor =  [UIColor colorWithHexString:@"0xefeef4"];
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(15, 0 ,0, 0));
        }];
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        self.titleLabel = titleLabel;
        
        
        UILabel * principalDescLabel = [[UILabel alloc] init];
        principalDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        principalDescLabel.font = [UIFont systemFontOfSize:10.5f];
        principalDescLabel.text = @"本金(元)";
        self.principalDescLabel = principalDescLabel;
        
        UILabel * principalMoneyLabel = [[UILabel alloc] init];
        principalMoneyLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        principalMoneyLabel.font = [UIFont systemFontOfSize:15.f];
        self.principalMoneyLabel = principalMoneyLabel;
        
        UILabel * rateDescLabel = [[UILabel alloc] init];
        rateDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        rateDescLabel.font = [UIFont systemFontOfSize:10.5f];
        rateDescLabel.text = @"利率(%)";
        self.rateDescLabel = rateDescLabel;
        
        UILabel * rateMoneyLabel = [[UILabel alloc] init];
        rateMoneyLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        rateMoneyLabel.font = [UIFont systemFontOfSize:15.f];
        self.rateMoneyLabel = rateMoneyLabel;
        
        UILabel * interestDescLabel = [[UILabel alloc] init];
        interestDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        interestDescLabel.font = [UIFont systemFontOfSize:10.5f];
        self.interestDescLabel = interestDescLabel;
        
        UILabel * interestMoneyLabel = [[UILabel alloc] init];
        interestMoneyLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        interestMoneyLabel.font = [UIFont systemFontOfSize:15.f];
        self.interestMoneyLabel = interestMoneyLabel;
        
        UILabel * anticipatePrincipalDescLabel = [[UILabel alloc] init];
        anticipatePrincipalDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        anticipatePrincipalDescLabel.font = [UIFont systemFontOfSize:10.5f];
        self.anticipatePrincipalDescLabel = anticipatePrincipalDescLabel;
        
        UILabel * anticipatePrincipalMoneyLabel = [[UILabel alloc] init];
        anticipatePrincipalMoneyLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        anticipatePrincipalMoneyLabel.font = [UIFont systemFontOfSize:15.f];
        self.anticipatePrincipalMoneyLabel = anticipatePrincipalMoneyLabel;
        
        UILabel * valueDateDescLabel = [[UILabel alloc] init];
        valueDateDescLabel.text = @"计息时间";
        valueDateDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        valueDateDescLabel.font = [UIFont systemFontOfSize:10.5f];
        self.valueDateDescLabel = valueDateDescLabel;
        
        UILabel * valueDateLabel = [[UILabel alloc] init];
        valueDateLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        valueDateLabel.font = [UIFont systemFontOfSize:15.f];
        self.valueDateLabel = valueDateLabel;
        
        UILabel * repaymentDateDescLabel = [[UILabel alloc] init];
        repaymentDateDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        repaymentDateDescLabel.font = [UIFont systemFontOfSize:10.5f];
        repaymentDateDescLabel.text = @"到期时间";
        self.repaymentDateDescLabel = repaymentDateDescLabel;
        
        UILabel * repaymentDateLabel = [[UILabel alloc] init];
        repaymentDateLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        repaymentDateLabel.font = [UIFont systemFontOfSize:15.f];
        self.repaymentDateLabel = repaymentDateLabel;
        
        HCCalendarRaiseView * raiseView = [[HCCalendarRaiseView alloc] init];
        raiseView.descString =@"加息10天";
        self.raiseView = raiseView;
        
        
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.titleLabel];

        [self.bgView addSubview:self.principalDescLabel];
        [self.bgView addSubview:self.principalMoneyLabel];
        [self.bgView addSubview:self.rateDescLabel];
        [self.bgView addSubview:self.rateMoneyLabel];
        [self.bgView addSubview:self.interestDescLabel];
        [self.bgView addSubview:self.interestMoneyLabel];
        [self.bgView addSubview:self.anticipatePrincipalDescLabel];
        [self.bgView addSubview:self.anticipatePrincipalMoneyLabel];
        [self.bgView addSubview:self.valueDateDescLabel];
        [self.bgView addSubview:self.valueDateLabel];
        [self.bgView addSubview:self.repaymentDateDescLabel];
        [self.bgView addSubview:self.repaymentDateLabel];
        [self.bgView addSubview:self.raiseView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        [self.principalDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(25);
        }];
        [self.principalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.principalDescLabel.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.principalDescLabel);
        }];
        
        [self.rateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView).mas_offset(15);
            make.centerY.mas_equalTo(self.principalDescLabel);
        }];
        [self.rateMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rateDescLabel.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.rateDescLabel);
        }];
        
        [self.raiseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rateMoneyLabel.mas_right).mas_offset(-20);
            make.bottom.mas_equalTo(self.rateMoneyLabel.mas_top);
        }];
        [self.interestDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.principalDescLabel.mas_bottom).mas_offset(15);
        }];
        [self.interestMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.interestDescLabel.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.interestDescLabel);

        }];
        
        [self.anticipatePrincipalDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rateDescLabel);
            make.top.mas_equalTo(self.rateDescLabel.mas_bottom).mas_offset(15);
        }];
        [self.anticipatePrincipalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.anticipatePrincipalDescLabel.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.anticipatePrincipalDescLabel);
        }];
        
        [self.valueDateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.interestDescLabel);
            make.top.mas_equalTo(self.interestDescLabel.mas_bottom).mas_offset(15);
        }];
        [self.valueDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.valueDateDescLabel.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.valueDateDescLabel);
        }];
        
        [self.repaymentDateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.anticipatePrincipalDescLabel);
            make.top.mas_equalTo(self.anticipatePrincipalDescLabel.mas_bottom).mas_offset(15);
        }];
        [self.repaymentDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.repaymentDateDescLabel.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.repaymentDateDescLabel);
            make.bottom.mas_equalTo(-15).priorityHigh();
        }];
    }
    return self;
}
- (void)setType:(int)type {
    _type = type;
    switch (type) {
        case 1:
        {
            self.interestDescLabel.text = self.model.billType==1?@"已收回款利息(元)":@"预计回款利息(元)";
            self.anticipatePrincipalDescLabel.text =self.model.billType==1?@"已收回款本金(元)":@"预计回款本金(元)";
        }
            break;
        case 2:
        {
            self.interestDescLabel.text = @"待收回款利息(元)";
            self.anticipatePrincipalDescLabel.text = @"待收回款本金(元)";
        }
            break;
    }
}
- (void)setModel:(HCCalendarDetailVoModel *)model {
    _model = model;
    self.titleLabel.text = model.projectName;
    self.principalMoneyLabel.text = [NSString stringWithFormat:@"%zd",model.investAmount.integerValue];
    if (model.couponRate) {
        self.raiseView.hidden = NO;
        if (model.raiseDays==model.valueDays) {
            self.raiseView.descString = @"全程加息";
        }else if (model.raiseDays==0){
            self.raiseView.hidden = YES;
        }else {
            self.raiseView.hidden = NO;
            self.raiseView.descString = [NSString stringWithFormat:@"加息%zd天",model.raiseDays];
        }
        self.rateMoneyLabel.text = [NSString stringWithFormat:@"%.2f+%.2f",model.baseRate,model.couponRate];
    }else{
        self.rateMoneyLabel.text = [NSString stringWithFormat:@"%.2f",model.baseRate];
        self.raiseView.hidden = YES;
    }
    
    self.interestMoneyLabel.text = [NSString stringWithFormat:@"%.2f",model.interestAmount.floatValue];
    self.anticipatePrincipalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",model.principalAmount.floatValue];
    self.valueDateLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.valueDate/1000.0]];
    self.repaymentDateLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.repaymentDate/1000.0]];

}
@end

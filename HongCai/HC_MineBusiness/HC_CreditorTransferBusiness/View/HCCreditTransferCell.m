//
//  HCCreditTransferCell.m
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCreditTransferCell.h"
#import "HCAssignmentModel.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCTimeTool.h"
#import "HCInterestRateView.h"
#import "HCMyInvestModel.h"
@interface HCCreditTransferCell()
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//本金
@property (nonatomic, strong) UILabel *principalLabel;
//收益
@property (nonatomic, strong) UILabel *earningsLabel;
//项目到期日
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIButton *transferButton;
@property (nonatomic, strong) HCInterestRateView *interestRateView;


@end

@implementation HCCreditTransferCell

- (void)setAssignModel:(HCAssignmentModel *)assignModel {
    _assignModel = assignModel;
    [self.interestRateView removeFromSuperview];
    [self.transferButton removeFromSuperview];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
    }];
    self.titleLabel.text = assignModel.name;
    self.principalLabel.text = [NSString stringWithFormat:@"%.2f",[assignModel.amount doubleValue]];
    self.earningsLabel.text = [NSString stringWithFormat:@"%.2f",[assignModel.soldStock doubleValue]*100.0];
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f",[assignModel.transferedIncome doubleValue]];
    self.leftLabel.text = @"转让(元)";
    self.middleLabel.text = @"已转(元)";
    self.rightLabel.text = @"收入(元)";
    
}

- (NSDate *)zeroOfDateWithDate:(NSDate *)date;
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}



- (void)setModel:(HCMyInvestModel *)model {
    
    _model = model;
    
    if (model.status==1||model.status==2) {
        self.principalLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        self.earningsLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
    }else{
        self.principalLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.earningsLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    self.titleLabel.text = model.projectName;
    self.principalLabel.text = [NSString stringWithFormat:@"%.2f",[model.amount doubleValue]];
    if ([model.couponValue doubleValue] >0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.top.mas_equalTo(15.f);
            make.right.mas_equalTo(self.interestRateView.mas_left).mas_offset(-5);
        }];
        NSString * profit = [NSString stringWithFormat:@"%.2f+",[model.profit doubleValue]];
        
        NSMutableAttributedString * profitString = [[NSMutableAttributedString alloc] initWithString:profit];
        
        NSString * couponProfit = [NSString stringWithFormat:@"%.2f",[model.couponProfit doubleValue]];
        
        NSAttributedString * couponProfitString = [[NSAttributedString alloc] initWithString:couponProfit attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:(model.status==1||model.status==2)?@"0xff611d":@"0x999999"]}];
        [profitString appendAttributedString:couponProfitString];
        
        self.earningsLabel.attributedText = profitString;
    }else{
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.top.mas_equalTo(15.f);
            make.right.mas_equalTo(self.transferButton.mas_left).mas_offset(-5);
        }];
        self.earningsLabel.text = [NSString stringWithFormat:@"%.2f",[model.profit doubleValue]];
    }
    if ([model.couponValue doubleValue] >0) {
        self.interestRateView.hidden = NO;
        self.interestRateView.descString = [NSString stringWithFormat:@"加息%@%%",model.couponValue.stringValue];
    }else{
        self.interestRateView.hidden = YES;
    }
    self.timeLabel.text = [HCTimeTool getDateWithTimeInterval:model.repaymentDate andTimeFormatter:@"yyyy/MM/dd"];
    
    self.titleLabel.text = model.projectName;
    self.principalLabel.text = [NSString stringWithFormat:@"%.2f",[model.amount doubleValue]];
    self.timeLabel.text = [HCTimeTool getDateWithTimeInterval:model.repaymentDate andTimeFormatter:@"yyyy/MM/dd"];
     NSDate *date1 = [NSDate date];
     NSDate * date2 =[NSDate dateWithTimeIntervalSince1970:[model.createTime doubleValue]/1000.0];
     date1 = [self zeroOfDateWithDate:date1];
     date2 = [self zeroOfDateWithDate:date2];
    
    NSTimeInterval resultTime = fabs([date1 timeIntervalSinceDate:date2]);
    double day =  resultTime/60.0/60.0/24.0;

    if (day>10) {
        [self.transferButton setTitle:@"可转" forState:UIControlStateNormal];
        self.transferButton.userInteractionEnabled = YES;
    }else{
        [self.transferButton setTitle:@"暂不可转" forState:UIControlStateNormal];
        self.transferButton.userInteractionEnabled = NO;
    }

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.principalLabel];
        [self.contentView addSubview:self.earningsLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.middleLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.transferButton];
        [self.contentView addSubview:self.interestRateView];

        
        self.leftLabel.text = @"本金(元)";
        self.middleLabel.text = @"收益(元)";
        self.rightLabel.text = @"项目到期日";
        
        [self layout_Masonry];
    
    }
    return self;
}

-(void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(15.f);
    }];
    
    [self.interestRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(5).priorityHigh();
        make.right.lessThanOrEqualTo(self.transferButton.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    CGSize size = [@"暂不可转" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width+12, size.height+5));
        self.transferButton.layer.cornerRadius = (size.height+5)*0.5;
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.titleLabel);
    }];

    //本金
    [self.principalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(30);

    }];

    //收益
    [self.earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.principalLabel);

    }];
    
  
    //项目到期日
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.principalLabel);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.principalLabel.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(15);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.leftLabel);
    }];
   
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftLabel);
        make.right.mas_equalTo(-15);
    }];
    self.contentView.layer.cornerRadius = 12.f;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15).priorityHigh();
        make.right.mas_equalTo(-15).priorityHigh();
        make.bottom.mas_equalTo(0).priorityHigh();
        make.top.mas_equalTo(0).priorityHigh();
    }];
}
- (void)transferButtonClick {
    if (self.transferButtonCallBack) {
        self.transferButtonCallBack();
    }
}

- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:CGRectGetWidth([UIScreen mainScreen].bounds)==320.0?13:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}
- (UILabel*)principalLabel {
    if (!_principalLabel){
        _principalLabel = [[UILabel alloc] init];
        _principalLabel.font = [UIFont systemFontOfSize:CGRectGetWidth([UIScreen mainScreen].bounds)==320.0?13:15];
        _principalLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _principalLabel;
}
- (UILabel*)earningsLabel {
    if (!_earningsLabel){
        _earningsLabel = [[UILabel alloc] init];
        _earningsLabel.font = [UIFont systemFontOfSize:CGRectGetWidth([UIScreen mainScreen].bounds)==320.0?13:15];
        
        _earningsLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _earningsLabel;
}
- (UILabel*)timeLabel {
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _timeLabel;
}

- (UILabel*)leftLabel {
    if (!_leftLabel){
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:10.5];
        _leftLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}
- (UILabel*)middleLabel {
    if (!_middleLabel){
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.font = [UIFont systemFontOfSize:10.5];
        _middleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _middleLabel;
}
- (UILabel*)rightLabel {
    if (!_rightLabel){
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:10.5];
        _rightLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}
- (UIButton *)transferButton {
    if (!_transferButton) {
        _transferButton=  [UIButton buttonWithType:UIButtonTypeSystem];
        [_transferButton setTitleColor:[UIColor colorWithHexString:@"0xfdb62b"] forState:UIControlStateNormal];
        [_transferButton setTitle:@"暂不可转" forState:UIControlStateNormal];
        _transferButton.layer.borderWidth = 1.f;
        _transferButton.layer.borderColor = _transferButton.currentTitleColor.CGColor;
        _transferButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_transferButton addTarget:self action:@selector(transferButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
}


- (HCInterestRateView *)interestRateView {
    if (!_interestRateView) {
        _interestRateView = [[HCInterestRateView alloc] init];
    }
    return _interestRateView;
}
@end

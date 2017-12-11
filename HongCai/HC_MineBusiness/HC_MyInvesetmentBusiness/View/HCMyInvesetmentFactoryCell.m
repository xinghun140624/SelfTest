//
//  HCMyInvesetmentFactoryCell.m
//  Pods
//
//  Created by Candy on 2017/6/27.
//
//

#import "HCMyInvesetmentFactoryCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCInterestRateView.h"
#import "HCMyInvestModel.h"
#import "HCTimeTool.h"
@interface HCMyInvesetmentFactoryCell()
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
@property (nonatomic, strong) HCInterestRateView *interestRateView;


@end

@implementation HCMyInvesetmentFactoryCell


- (void)setFrame:(CGRect)frame {
    CGFloat width = frame.size.width;
    width-=30;
    CGFloat x = frame.origin.x;
    x +=15;
    frame.origin.x = x;
    frame.size.width = width;
    [super setFrame:frame];
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
    self.principalLabel.text = [NSString stringWithFormat:@"%d",[model.amount intValue]];
    if ([model.couponValue doubleValue] >0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.interestRateView.mas_left).mas_offset(-5);
            make.left.mas_equalTo(15.f);
            make.top.mas_equalTo(15.f);
        }];
        NSString * profit = [NSString stringWithFormat:@"%.2f+",[model.profit doubleValue]];
        
        NSMutableAttributedString * profitString = [[NSMutableAttributedString alloc] initWithString:profit];
        
        NSString * couponProfit = [NSString stringWithFormat:@"%.2f",[model.couponProfit doubleValue]];
        
        NSAttributedString * couponProfitString = [[NSAttributedString alloc] initWithString:couponProfit attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:(model.status==1||model.status==2)?@"0xff611d":@"0x999999"]}];
        [profitString appendAttributedString:couponProfitString];
        
        self.earningsLabel.attributedText = profitString;
    }else{
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15.f);
            make.left.mas_equalTo(15.f);
            make.top.mas_equalTo(15.f);
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
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.cornerRadius = 12.f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.principalLabel];
        [self.contentView addSubview:self.earningsLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.middleLabel];
        [self.contentView addSubview:self.rightLabel];
        
        [self.contentView addSubview:self.interestRateView];
        self.leftLabel.text = @"本金(元)";
        self.middleLabel.text = @"预计总收益(元)";
        self.rightLabel.text = @"项目到期日";
       
        [self layout_Masonry];
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
}
-(void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(15.f);
    }];
    
    [self.interestRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(5).priorityHigh();
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_lessThanOrEqualTo(-5);
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
        if (CGRectGetWidth([UIScreen mainScreen].bounds)==320) {
            make.right.mas_equalTo(-5);
        }else{
            make.right.mas_equalTo(-15);
        }
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
    
}

- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}
- (UILabel*)principalLabel {
    if (!_principalLabel){
        _principalLabel = [[UILabel alloc] init];
        _principalLabel.font = [UIFont systemFontOfSize:15.f];
        _principalLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    return _principalLabel;
}
- (UILabel*)earningsLabel {
    if (!_earningsLabel){
        _earningsLabel = [[UILabel alloc] init];
        _earningsLabel.font = [UIFont systemFontOfSize:15];
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
- (HCInterestRateView *)interestRateView {
    if (!_interestRateView) {
        _interestRateView = [[HCInterestRateView alloc] init];
    }
    return _interestRateView;
}
@end

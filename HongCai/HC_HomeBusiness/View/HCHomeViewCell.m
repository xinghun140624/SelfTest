//
//  HCHomeViewCell.m
//  HongCai
//
//  Created by Candy on 2017/6/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCHomeViewCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCProjectModel.h"
@interface HCHomeViewCell ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *logoTextLabel;

@property (nonatomic, strong) UILabel *titleLabel;
//利率
@property (nonatomic, strong) UILabel *interestRateLabel;
//期限
@property (nonatomic, strong) UILabel *timeLimitLabel;

//剩余金额
@property (nonatomic, strong) UILabel *remainLabel;

//起投
@property (nonatomic, strong) UILabel *startLabel;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIImageView *finishImageView;
@property (nonatomic, strong) UIImageView *hotImageView;

@end


@implementation HCHomeViewCell
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.logoImageView];
        [self.logoImageView addSubview:self.logoTextLabel];
        [self.contentView addSubview:self.moreButton];

        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.hotImageView];
        [self.contentView addSubview:self.interestRateLabel];
        [self.contentView addSubview:self.timeLimitLabel];
        [self.contentView addSubview:self.remainLabel];
        [self.contentView addSubview:self.startLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.middleLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.finishImageView];

       
        
        [self layout_Masonry];

    }
    return self;
}
- (void)setProject:(HCProjectModel *)project {
    _project = project;
    HCProjectSubModel * projectModel = project.projectList.firstObject;
    self.titleLabel.text = projectModel.name;
    NSString *earningStr =  [NSString stringWithFormat:@"%.2f%%",[projectModel.annualEarnings doubleValue]];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:earningStr];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(string.length-1, 1)];
    self.interestRateLabel.attributedText = string;
    self.timeLimitLabel.text =[NSString stringWithFormat:@"%@天期限",projectModel.projectDays];
    if ([projectModel.status integerValue]==7) {
        self.remainLabel.text = [NSString stringWithFormat:@"剩余%.2f万",[projectModel.amount floatValue]/10000.0];
        self.finishImageView.hidden = YES;
        self.interestRateLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        self.hotImageView.hidden = NO;
        self.layer.shadowColor = [UIColor colorWithHexString:@"0xfab513"].CGColor;
    }else{
        self.layer.shadowColor = [UIColor colorWithHexString:@"0x39d5c9"].CGColor;
        self.hotImageView.hidden = YES;
        self.remainLabel.text = @"剩余0元";
        self.finishImageView.hidden = NO;
        self.interestRateLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }
    self.startLabel.text = [NSString stringWithFormat:@"%@元起投",projectModel.increaseAmount];
}
- (void)layout_Masonry {
    
    CGFloat padding = 15;
    if (CGRectGetWidth([UIScreen mainScreen].bounds)) {
        padding = 25;
    }
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-5);
        make.left.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(66, 26.5));
    }];
    [self.logoTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.logoImageView);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.logoImageView.mas_centerY).mas_offset(5);
        
        make.right.mas_equalTo(-padding+3);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
        make.left.mas_greaterThanOrEqualTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).mas_offset(5);

    }];
    [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel).priorityHigh();
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(5.f);
        make.right.mas_lessThanOrEqualTo(self.moreButton.mas_right).mas_offset(-6);
    }];
    
    NSString * text = @"9.5";
    CGSize interestRate = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:34.f]}];
    [self.interestRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_greaterThanOrEqualTo(interestRate.height);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20).priorityHigh();

    }];
    NSString * text2 = @"哈哈";
    CGSize timeLintSize = [text2 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
    [self.timeLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftLabel.mas_centerX);
        make.top.mas_equalTo(self.interestRateLabel.mas_bottom).mas_offset(10);
        make.height.mas_greaterThanOrEqualTo(timeLintSize.height);

    }];
    
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.middleLabel.mas_centerX);
        make.centerY.mas_equalTo(self.timeLimitLabel);
        make.height.mas_equalTo(self.timeLimitLabel);
    }];
    
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rightLabel.mas_centerX);
        make.centerY.mas_equalTo(self.timeLimitLabel);
        make.height.mas_equalTo(self.timeLimitLabel);
    }];

    
    NSString * middleText = @"即投即计息";
    CGSize size = [middleText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        self.middleLabel.layer.cornerRadius = (size.height+8.0)/2.0;
        make.size.mas_equalTo(CGSizeMake(size.width+10, size.height+8)).priorityHigh();
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.timeLimitLabel.mas_bottom).mas_equalTo(10);
        make.bottom.mas_equalTo(-15);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftLabel.layer.cornerRadius = (size.height+8.0)/2.0;
        make.size.mas_equalTo(self.middleLabel);
        make.centerY.mas_equalTo(self.middleLabel);
        make.left.mas_equalTo(padding);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.rightLabel.layer.cornerRadius = (size.height+8.0)/2.0;
        make.size.mas_equalTo(self.middleLabel);
        make.centerY.mas_equalTo(self.middleLabel);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-padding);
    }];
    [self.finishImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
    }];
   
    
}
- (void)moreButtonClick {
    if (self.moreButtonClickCallBack) {
        self.moreButtonClickCallBack();
    }
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
    }
    return _logoImageView;
}
- (UILabel*)logoTextLabel {
    if (!_logoTextLabel){
        _logoTextLabel = [[UILabel alloc] init];
        _logoTextLabel.font = [UIFont systemFontOfSize:10];
        _logoTextLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
    }
    return _logoTextLabel;
}
- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}
- (UILabel*)interestRateLabel {
    if (!_interestRateLabel){
        _interestRateLabel = [[UILabel alloc] init];
        _interestRateLabel.font = [UIFont systemFontOfSize:34.f];
        _interestRateLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _interestRateLabel;
}
- (UILabel*)remainLabel {
    if (!_remainLabel){
        _remainLabel = [[UILabel alloc] init];
        _remainLabel.font = [UIFont systemFontOfSize:15];
        _remainLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
    }
    return _remainLabel;
}
- (UILabel*)timeLimitLabel {
    if (!_timeLimitLabel){
        _timeLimitLabel = [[UILabel alloc] init];
        _timeLimitLabel.font = [UIFont systemFontOfSize:15];
        _timeLimitLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
    }
    return _timeLimitLabel;
}
- (UILabel*)startLabel {
    if (!_startLabel){
        _startLabel = [[UILabel alloc] init];
        _startLabel.font = [UIFont systemFontOfSize:15];
        _startLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
    }
    return _startLabel;
}
- (UILabel*)leftLabel {
    if (!_leftLabel){
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:10];
        _leftLabel.textColor = [UIColor colorWithHexString:@"0xe1a938"];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.layer.borderWidth = 1.f;
        _leftLabel.layer.borderColor = _leftLabel.textColor.CGColor;
    }
    return _leftLabel;
}
- (UILabel*)middleLabel {
    if (!_middleLabel){
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.font = [UIFont systemFontOfSize:10];
        _middleLabel.textColor = [UIColor colorWithHexString:@"0xe1a938"];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.layer.borderWidth = 1.f;
        _middleLabel.layer.borderColor = _middleLabel.textColor.CGColor;
    }
    return _middleLabel;
}
- (UILabel*)rightLabel {
    if (!_rightLabel){
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:10];
        _rightLabel.textColor = [UIColor colorWithHexString:@"0xe1a938"];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.layer.borderWidth = 1.f;
        _rightLabel.layer.borderColor = _rightLabel.textColor.CGColor;
    }
    return _rightLabel;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"0xfdc14b"] forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (UIImageView *)finishImageView {
    if (!_finishImageView) {
        _finishImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_ysq_nor"]];
        _finishImageView.hidden = YES;
    }
    return _finishImageView;
}
- (UIImageView *)hotImageView {
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tz_iocn_hot_nor"]];
    }
    return _hotImageView;
}

@end

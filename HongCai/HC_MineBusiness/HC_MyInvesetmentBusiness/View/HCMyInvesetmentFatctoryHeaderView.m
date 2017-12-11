//
//  HCMyInvesetmentFatctoryHeaderView.m
//  Pods
//
//  Created by Candy on 2017/6/27.
//
//

#import "HCMyInvesetmentFatctoryHeaderView.h"
#import "NSBundle+HCMyInvesetmentModule.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

@interface HCMyInvesetmentFatctoryHeaderView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation HCMyInvesetmentFatctoryHeaderView
- (void)setData:(NSDictionary *)data {
    _data = data;
    if (data) {
        NSString * leftStr = [NSString stringWithFormat:@"%.2f",[data[@"totalInvestAmount"] doubleValue]];
        NSDecimalNumber * profit = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",data[@"profit"]]];
        NSDecimalNumber * couponProfit = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",data[@"couponProfit"]]];
        NSDecimalNumber * discountInterest = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",data[@"discountInterest"]]];


        
        NSDecimalNumber * totalProfit = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",data[@"totalProfit"]]];
        NSDecimalNumber * couponReturnProfit = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",data[@"couponReturnProfit"]]];
        
        //总收益
        NSDecimalNumber * total = [[[[profit decimalNumberByAdding:couponProfit] decimalNumberByAdding:discountInterest] decimalNumberBySubtracting:totalProfit] decimalNumberBySubtracting:couponReturnProfit];
        
        //已收收益
        NSDecimalNumber * receivedProfit = [totalProfit decimalNumberByAdding:couponReturnProfit];
        
        //
        
        
        
        
        NSString * middleStr = [NSString stringWithFormat:@"%.2f",[total doubleValue]];
        NSString * rightStr = [NSString stringWithFormat:@"%.2f",[receivedProfit doubleValue]];
        
        self.leftLabel.attributedText = [self attrWithMoneyStr:leftStr LastStr:@"待收本金(元)"];
        self.middleLabel.attributedText = [self attrWithMoneyStr:middleStr LastStr:@"待收收益(元)"];
        self.rightLabel.attributedText = [self attrWithMoneyStr:rightStr LastStr:@"已收收益(元)"];
    }else {
        self.leftLabel.attributedText = [self attrWithMoneyStr:@"0.00" LastStr:@"待收本金(元)"];
        self.middleLabel.attributedText = [self attrWithMoneyStr:@"0.00" LastStr:@"待收收益(元)"];
        self.rightLabel.attributedText = [self attrWithMoneyStr:@"0.00" LastStr:@"已收收益(元)"];
    }
 
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.leftLabel];
        [self.bgImageView addSubview:self.middleLabel];
        [self.bgImageView addSubview:self.rightLabel];
        
        [self layout_Masonry];
      

        
    }
    return self;
}
- (NSMutableAttributedString *)attrWithMoneyStr:(NSString *)moneyStr LastStr:(NSString *)str {
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 3.f;
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:moneyStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.f],NSParagraphStyleAttributeName:style}];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:str] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.5]}]];
    return attr;
}
- (void)layout_Masonry {
    UIImage * image = [NSBundle myInvesetment_ImageWithName:@"wdtz_bg_xmxq_nor"];
    CGFloat height = [UIScreen mainScreen].bounds.size.width *image.size.height/image.size.width;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    NSArray * labelArray = @[self.leftLabel,self.middleLabel,self.rightLabel];
    [labelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [labelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgImageView);
    }];
    
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHexString:@"0xfffefe"];
    [self addSubview:line1];
    
    UIView * line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithHexString:@"0xfffefe"];
    [self addSubview:line2];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right);
        make.height.mas_equalTo(28.f);
        make.centerY.mas_equalTo(self.leftLabel);
        make.width.mas_equalTo(0.5f);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.middleLabel.mas_right);
        make.height.mas_equalTo(28.f);
        make.centerY.mas_equalTo(self.middleLabel);
        make.width.mas_equalTo(0.5f);
    }];
    
    
}
- (UIImageView*)bgImageView {
    if (!_bgImageView){
        _bgImageView = [[UIImageView alloc] initWithImage:[NSBundle myInvesetment_ImageWithName:@"wdtz_bg_xmxq_nor"]];
    }
    return _bgImageView;
}
- (UILabel*)leftLabel {
    if (!_leftLabel){
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.font = [UIFont systemFontOfSize:18.f];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.numberOfLines = 0;

    }
    return _leftLabel;
}
- (UILabel*)middleLabel {
    if (!_middleLabel){
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.textColor = [UIColor whiteColor];
        _middleLabel.font = [UIFont systemFontOfSize:18.f];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.numberOfLines = 0;

    }
    return _middleLabel;
}
- (UILabel*)rightLabel {
    if (!_rightLabel){
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.font = [UIFont systemFontOfSize:18.f];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.numberOfLines = 0;

    }
    return _rightLabel;
}
@end

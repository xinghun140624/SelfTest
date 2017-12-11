//
//  HCImmediatelyInputCell.m
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCImmediatelyInputCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+HCCreditorTransferModule.h"
#import "HCUserCreditRightDetailModel.h"
#import "HCAssignmentRuleModel.h"
#import "HCTimeTool.h"
@interface HCImmediatelyInputCell() <UITextFieldDelegate>
//标题
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel * amountStatusLabel;
@property (nonatomic, strong) UIImageView * amountIconView;
//转让金额
@property (nonatomic, strong) UITextField *amountInputTextField;

@property (nonatomic, strong) UILabel * ratetatusLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UIImageView * rateIconView;
@property (nonatomic, strong) UILabel * rateStatusLabel;

//转让利率
@property (nonatomic, strong) UITextField *rateInputTextField;

@property (nonatomic, strong) UILabel *statuLabel;

@end
@implementation HCImmediatelyInputCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
      
        [self.contentView addSubview:self.amountLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

        CGSize size = [@"转让金额" sizeWithAttributes:@{NSFontAttributeName:self.amountLabel.font}];
        
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.top.mas_equalTo(35.f);
            make.width.mas_equalTo(size.width +5);
        }];
        
        [self.contentView addSubview:self.rateLabel];
    
        
        UIView * bgView1 = [UIView new];
        bgView1.backgroundColor = [UIColor whiteColor];
        bgView1.layer.borderWidth = 0.5f;
        bgView1.layer.borderColor = [UIColor colorWithHexString:@"0xeeeeee"].CGColor;
        bgView1.layer.cornerRadius = 3.f;

        [self.contentView addSubview:bgView1];
        [bgView1 addSubview:self.amountInputTextField];
        
        UIView * bgView2 = [UIView new];
        bgView2.backgroundColor = [UIColor whiteColor];
        bgView2.layer.borderWidth = 0.5f;
        bgView2.layer.borderColor = [UIColor colorWithHexString:@"0xeeeeee"].CGColor;
        bgView2.layer.cornerRadius = 3.f;
        
        [self.contentView addSubview:bgView2];
        
        [bgView2 addSubview:self.rateInputTextField];
        
        self.amountInputTextField.delegate = self;
        self.rateInputTextField.delegate = self;
      
        [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.amountLabel.mas_right).mas_offset(20.f);
            make.centerY.mas_equalTo(self.amountLabel);
            make.right.mas_equalTo(-20.f);
            make.height.mas_equalTo(35.f);
        }];
        [self.contentView addSubview:self.amountStatusLabel];
        [self.contentView addSubview:self.amountIconView];
        
        [self.amountIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.amountLabel.mas_right).mas_offset(25.f);
            make.bottom.mas_equalTo(bgView1.mas_top).mas_offset(-3);
        }];
        

        [self.amountStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.amountIconView.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.amountIconView);

        }];
        
        
        [self.amountInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 40));
        }];
        
        [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.mas_equalTo(bgView1);
            make.top.mas_equalTo(bgView1.mas_bottom).mas_offset(30.f);
        }];
        
        [self.contentView addSubview:self.rateIconView];
        [self.contentView addSubview:self.rateStatusLabel];
        
        [self.rateIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView2.mas_left).mas_offset(3);
            make.bottom.mas_equalTo(bgView2.mas_top).mas_offset(-3);
        }];
        
        [self.rateStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rateIconView.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(self.rateIconView);
            
        }];
        UILabel *yuanLabel = [[UILabel alloc] init];
        yuanLabel.text = @"元";
        yuanLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        yuanLabel.font =[UIFont systemFontOfSize:15];
        [bgView1 addSubview:yuanLabel];
        
        [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8.f);
            make.centerY.mas_equalTo(bgView1);
        }];
        
        
        UILabel * baifenLabel = [[UILabel alloc] init];
        baifenLabel.text = @"%";
        baifenLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        baifenLabel.font =[UIFont systemFontOfSize:15];
        [bgView2 addSubview:baifenLabel];
        
        [baifenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8.f);
            make.centerY.mas_equalTo(bgView2);
        }];
        
        [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.centerY.mas_equalTo(bgView2);
        }];
        [self.rateInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 40));
        }];
        
        [self.contentView addSubview:self.statuLabel];
        
        [self.statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView2.mas_bottom).mas_offset(5.f);
            make.left.mas_equalTo(bgView2.mas_left).mas_offset(5.f);
            make.bottom.mas_equalTo(-10.f);
        }];
        
        
        self.amountLabel.text = @"转让金额";
        self.rateLabel.text = @"转让利率";
        
        NSString * myString = @"当前转让奖金预计0元";
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:myString];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, 1)];
        self.statuLabel.attributedText = attrString;

        
    }
    return self;
}

- (void)textFieldDidChange:(NSNotification *)notification {
   
    BOOL amountSuccess = NO;
    BOOL rateSuccess = NO;

    if (([self.amountInputTextField.text integerValue]%100==0 && [self.amountInputTextField.text integerValue]>=100 &&[self.amountInputTextField.text integerValue] <= [self.remainAmount integerValue])||self.amountInputTextField.text.length==0) {
        self.amountIconView.hidden = YES;
        self.amountStatusLabel.hidden = self.amountIconView.isHidden;
        amountSuccess = YES;
    }else{
        
        self.amountIconView.hidden= NO;
        self.amountStatusLabel.hidden = self.amountIconView.isHidden;
        amountSuccess = NO;

        if ([self.amountInputTextField.text integerValue] > [self.remainAmount integerValue]){
            self.amountStatusLabel.text = [NSString stringWithFormat:@"转让金额最高为%zd元",[self.remainAmount integerValue]];
        }else{
            self.amountStatusLabel.text = @"转让金额必须为100的整数倍";
        }
    }
    if ([self.rateInputTextField.text doubleValue]>0&& (int)((self.minRate.doubleValue*100)- [self.rateInputTextField.text doubleValue]*100) >=1) {
        self.rateIconView.hidden = NO;
        self.rateStatusLabel.hidden = self.rateIconView.isHidden;
        self.rateStatusLabel.text =[NSString stringWithFormat:@"最小转让率为%.2f%%",[self.minRate doubleValue]];
        rateSuccess = NO;
    }else{
        self.rateIconView.hidden = YES;
        self.rateStatusLabel.hidden = self.rateIconView.isHidden;
        rateSuccess = YES;
    }
    
    
    
    NSInteger inputAmount = [self.amountInputTextField.text integerValue];
    
    
    
    
    if (inputAmount>0 && self.rateInputTextField.text.length >0) {
        double amount = [self getTransferMoneyWithValue:inputAmount];
        
        NSString * string = [self notRounding:amount afterPoint:2];
        NSString * myString = [NSString stringWithFormat:@"当前转让奖金预计%@元",string];

        
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:myString];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, string.length)];
        
        self.statuLabel.attributedText = attrString;
    }else{
        
        NSString * myString = @"当前转让奖金预计0元";
        
        
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:myString];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(8, 1)];
        
        self.statuLabel.attributedText = attrString;

    }
    
    
    if (inputAmount >0 && self.rateInputTextField.text.length >0) {
        double  result = 0.00;
        
        if (self.detailModel.couponModel.type.integerValue==2) {
            //现金券
            result  = inputAmount + [self getWaitNotGetInterest] - [self getCounterfee]- [self getMoreCashCouponearnings] - [self getLiCha] - [self getMoney];

        }else{
          result  = inputAmount + [self getWaitNotGetInterest] - [self getCounterfee]- [self getMoreCashCouponearnings] - [self getLiCha];

        }
        if (self.caculateResultCallBack) {
            self.caculateResultCallBack(result,(amountSuccess&&rateSuccess));
        }
    }else{
        if (self.caculateResultCallBack) {
            self.caculateResultCallBack(0.00,(NO));
        }
    }
}
- (double)getMoney {

    double value = self.detailModel.couponModel.value.doubleValue * [self.amountInputTextField.text doubleValue]/[self.detailModel.creditRightModel.amount doubleValue];
    
    return value;
}
- (double)getMaxTransferRate {
    

    NSInteger  accessDay =  [HCTimeTool getTimeDistanceDate1:self.detailModel.projectModel.repaymentDate date2:[[NSDate date] timeIntervalSince1970]*1000.0];

    
    return 36500* (1- [self.ruleModel.maxReceivedPaymentsRate doubleValue])/accessDay + [self.detailModel.projectModel.annualEarnings doubleValue];

}

//待收未收利息
- (double)getWaitNotGetInterest {
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970]*1000.0;
    
    NSInteger  accessDay =[HCTimeTool getTimeDistanceDate1:self.detailModel.projectBillModel.lastRepaymentTime date2:[[NSDate date] timeIntervalSince1970]*1000.0];
    
    if (nowTimeInterval < self.detailModel.projectBillModel.lastRepaymentTime) {
        accessDay *= -1;
    }

    double amount = [self.detailModel.projectModel.annualEarnings doubleValue] * [self.amountInputTextField.text doubleValue] * accessDay/36500.0;
    return amount;
}
-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

//当前奖金
- (double )getTransferMoneyWithValue:(double)inputValue {
    double  amount = [self.amountInputTextField.text doubleValue];
    double annualEarnings = [self.rateInputTextField.text doubleValue] - [self.detailModel.projectModel.annualEarnings doubleValue];
    NSInteger  accessDay  = [HCTimeTool getTimeDistanceDate1:self.detailModel.projectModel.repaymentDate date2:[[NSDate date] timeIntervalSince1970]*1000.0];

    return amount * accessDay * annualEarnings/36500.00;
    
}
//获取手续费
- (double)getCounterfee {
    NSInteger dat_time_in_mills = 24*60*60*1000;
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970]*1000.0 ;
    double getCounterfee = 0.0;
    
    double inputAmount = [self.amountInputTextField.text doubleValue];
    double createTime = [self.detailModel.creditRightModel.createTime doubleValue];
    
    NSInteger borderDay = [self.ruleModel.borderDay integerValue];
    
    double lessThanOrEqualBorderDayFee = [self.ruleModel.lessThanOrEqualBorderDayFee doubleValue];
    double discountFeeRate = [self.ruleModel.discountFeeRate doubleValue];
    double minFee = [self.ruleModel.minFee doubleValue];
    double greaterThanBorderDayFee = [self.ruleModel.greaterThanBorderDayFee doubleValue];
    
    if ((nowTimeInterval - createTime)<= (borderDay*dat_time_in_mills)) {
        getCounterfee =  (inputAmount *lessThanOrEqualBorderDayFee /100 *discountFeeRate);
        return getCounterfee>minFee?getCounterfee:minFee;
    }else {
        getCounterfee =  (inputAmount *greaterThanBorderDayFee /100 *discountFeeRate);
        return getCounterfee>minFee?getCounterfee:minFee;
    }
}
//获得利差
- (double)getLiCha {
    double inputAmount = [self.amountInputTextField.text doubleValue];
    
    NSInteger accessDay = [HCTimeTool getTimeDistanceDate1:self.detailModel.projectModel.repaymentDate date2:[[NSDate date] timeIntervalSince1970]*1000.0];
    
    
    double licha = ([self.rateInputTextField.text doubleValue] - [self.detailModel.projectModel.annualEarnings doubleValue]) *inputAmount *accessDay/36500;
    
    return licha;
}

//获取多得的现金券的收益
- (double)getMoreCashCouponearnings {
    double inputAmount = [self.amountInputTextField.text doubleValue];
    if (!self.ruleModel.recycleReward) {
        return 0.0;
    }
    if (!(self.detailModel.creditRightModel.type==2 && self.detailModel.creditRightModel)) {
        return 0.0;
    }
    return [self.detailModel.couponModel.value doubleValue] *(inputAmount/[self.detailModel.creditRightModel.amount doubleValue]);
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isHaveDian = NO;
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            return NO;
        }
        
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
        
    }

    return YES;
}

- (UIImageView*)amountIconView {
    if (!_amountIconView){
        _amountIconView = [[UIImageView alloc] initWithImage:[NSBundle creditorTransfer_ImageWithName:@"srje_iocn_ts_nor"]];
        _amountIconView.hidden = YES;
    }
    return _amountIconView;
}
- (UILabel *)amountStatusLabel {
    if (!_amountStatusLabel) {
        _amountStatusLabel = [[UILabel alloc] init];
        _amountStatusLabel.textColor = [UIColor colorWithHexString:@"0xff0000"];
        _amountStatusLabel.font = [UIFont systemFontOfSize:12];
        _amountStatusLabel.hidden = YES;
    }
    return _amountStatusLabel;
}
- (UIImageView*)rateIconView {
    if (!_rateIconView){
        _rateIconView = [[UIImageView alloc] initWithImage:[NSBundle creditorTransfer_ImageWithName:@"srje_iocn_ts_nor"]];
        _rateIconView.hidden = YES;
    }
    return _rateIconView;
}
- (UILabel *)rateStatusLabel {
    if (!_rateStatusLabel) {
        _rateStatusLabel = [[UILabel alloc] init];
        _rateStatusLabel.textColor = [UIColor colorWithHexString:@"0xff0000"];
        _rateStatusLabel.font = [UIFont systemFontOfSize:12];
        _amountStatusLabel.hidden = YES;

    }
    return _rateStatusLabel;
}

- (UILabel *)statuLabel {
    if (!_statuLabel) {
        _statuLabel = [[UILabel alloc] init];
        _statuLabel.font = [UIFont systemFontOfSize:10];
        _statuLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _statuLabel;
}
- (UILabel*)amountLabel {
    if (!_amountLabel){
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:15];
        _amountLabel.textColor = [UIColor colorWithHexString:@"0x666666"];

    }
    return _amountLabel;
}
- (UITextField *)amountInputTextField {
    if (!_amountInputTextField){
        _amountInputTextField = [[UITextField alloc] init];
        _amountInputTextField.font = [UIFont systemFontOfSize:15.f];
         NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入100的正整数倍" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _amountInputTextField.attributedPlaceholder = placeholderText;
        _amountInputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _amountInputTextField.borderStyle = UITextBorderStyleNone;
        _amountInputTextField.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _amountInputTextField;
}

- (UILabel*)rateLabel {
    if (!_rateLabel){
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.font = [UIFont systemFontOfSize:15];
        _rateLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _rateLabel;
}

- (UITextField *)rateInputTextField {
    if (!_rateInputTextField){
        _rateInputTextField = [[UITextField alloc] init];
        _rateInputTextField.font = [UIFont systemFontOfSize:15.f];
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"请输入转让利率" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _rateInputTextField.attributedPlaceholder = placeholderText;
        _rateInputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _rateInputTextField.borderStyle = UITextBorderStyleNone;
        _rateInputTextField.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _rateInputTextField;
}

@end

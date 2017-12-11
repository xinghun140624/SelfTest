//
//  HCPurchasingFirstView.m
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGoToInvestHomeView.h"
#import "NSBundle+GoToInvestModule.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface HCGoToInvestHomeView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView  *bottomLine1;
@property (nonatomic, strong) UIView  *bottomLine2;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation HCGoToInvestHomeView
- (void)setUserBalance:(NSNumber *)userBalance {
    _userBalance = userBalance;
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:@"账户余额：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    //用户余额
    NSString * userBalanceOriginalStr = [NSString stringWithFormat:@"%.2f元",[userBalance floatValue]];
    NSAttributedString * userBalanceStr = [[NSAttributedString alloc] initWithString:userBalanceOriginalStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]}];
    [mutableStr appendAttributedString:userBalanceStr];
    self.balanceLabel.attributedText  = mutableStr;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        [IQKeyboardManager sharedManager].enable = NO;
        [self addSubview:self.closeButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.topLine];
        [self addSubview:self.balanceLabel];
        [self addSubview:self.iconView];
        [self addSubview:self.descLabel];
        
        [self addSubview:self.bottomLine1];
        [self addSubview:self.bottomLine2];
        [self addSubview:self.moneyTextField];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.nextButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        [self layout_Masonry];
        if ([self.moneyTextField canBecomeFirstResponder]) {
            [self.moneyTextField becomeFirstResponder];
        }
    }
    return self;
}
- (void)layout_Masonry {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.closeButton);
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(45.f);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.topLine.mas_bottom).mas_offset(20.f);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(self.balanceLabel.mas_bottom).mas_offset(35);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(8.f);
        make.centerY.mas_equalTo(self.iconView);
    }];
    [self.bottomLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.balanceLabel.mas_bottom).mas_equalTo(50.f);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.65);
        make.height.mas_equalTo(0.5f);
    }];
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.65-40);
        make.top.mas_equalTo(self.bottomLine1.mas_bottom);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moneyTextField.mas_right);
        make.centerY.mas_equalTo(self.moneyTextField);;
    }];
    
    [self.bottomLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomLine1);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.65);
        make.top.mas_equalTo(self.moneyTextField.mas_bottom);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomLine1.mas_top);
        make.left.mas_equalTo(self.bottomLine1.mas_right);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomLine2.mas_bottom);
    }];
    
}

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
#pragma -mark events

- (void)closeButtonClick:(UIButton *)button {
   
    [[self getCurrentViewController] dismissViewControllerAnimated:NO completion:^{
        if (self.moneyTextField.isFirstResponder) {
            [self.moneyTextField resignFirstResponder];
        }
    }];
}
- (void)nextButtonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(goToInvestHomeView:nextButtonClick:)]) {
        [self.delegate goToInvestHomeView:self nextButtonClick:button];
    }
}


- (void)textDidChange:(NSNotification *)notification {
    if ([self.moneyTextField.text integerValue]%100==0 && [self.moneyTextField.text integerValue]>=100 &&[self.moneyTextField.text integerValue] <= [self.remainNumber integerValue]) {
        self.nextButton.enabled = YES;
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"0xFA4918"];
        self.iconView.hidden = YES;
        self.descLabel.hidden = self.iconView.isHidden;
        
    }else{
        self.nextButton.enabled = NO;
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"0x999999"];
        self.iconView.hidden = NO;
        if ([self.moneyTextField.text integerValue] > [self.remainNumber integerValue]){
            self.descLabel.text = [NSString stringWithFormat:@"投资金额最高为%zd元",[self.remainNumber integerValue]];
        }else{
            self.descLabel.text = @"投资金额必须为100的整数倍";

        }
        
        self.descLabel.hidden = self.iconView.isHidden;
    }
    
}
- (UIButton*)closeButton {
    if (!_closeButton){
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * closeImage = [NSBundle goToInvest_ImageWithName:@"Registration_icon_close_Dark_nor"];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"输入金额";
    }
    return _titleLabel;
}
- (UIView*)topLine {
    if (!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    }
    return _topLine;
}
- (UILabel*)balanceLabel {
    if (!_balanceLabel){
        _balanceLabel = [[UILabel alloc] init];
    }
    return _balanceLabel;
}
- (UIImageView*)iconView {
    if (!_iconView){
        _iconView = [[UIImageView alloc] initWithImage:[NSBundle goToInvest_ImageWithName:@"srje_iocn_ts_nor"]];
        _iconView.hidden = YES;
    }
    return _iconView;
}
- (UILabel *)descLabel {
    if (!_descLabel){
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexString:@"0xff0000"];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.text = @"投资金额必须为100的整数倍";
        _descLabel.hidden = YES;
        
    }
    return _descLabel;
}
- (UIView*)bottomLine1 {
    if (!_bottomLine1){
        _bottomLine1 = [[UIView alloc] init];
        _bottomLine1.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
    }
    return _bottomLine1;
}
- (UIView*)bottomLine2 {
    if (!_bottomLine2){
        _bottomLine2 = [[UIView alloc] init];
        _bottomLine2.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
    }
    return _bottomLine2;
}
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextButton.enabled = NO;
        _nextButton.backgroundColor = [UIColor colorWithHexString:@"0x999999"];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTintColor:[UIColor whiteColor]];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
- (UITextField *)moneyTextField {
    if (!_moneyTextField) {
        _moneyTextField = [[UITextField alloc] init];
        _moneyTextField.borderStyle = UITextBorderStyleNone;
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:@"100起投" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        _moneyTextField.attributedPlaceholder = placeholderText;
        _moneyTextField.font = [UIFont systemFontOfSize:15];
        _moneyTextField.textColor = [UIColor colorWithHexString:@"0x666666"];
        _moneyTextField.tintColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _moneyTextField.textAlignment = NSTextAlignmentCenter;
        _moneyTextField.delegate = self;
    }
    return _moneyTextField;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"元";
        _moneyLabel.font = [UIFont systemFontOfSize:17];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _moneyLabel;
}


@end
